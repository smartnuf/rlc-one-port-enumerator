(* ::Package:: *)

(* ::Package:: *)
(**)


BeginPackage["GraphCollectionTools`"]

importG6Files::usage =
  "importG6Files[dir, pattern] imports all files matching pattern (default \"*.g6\")\n\
from directory dir (and subdirectories) as graphs in Graph6 format. It returns an\n\
association mapping file base names to imported graphs.";

indexGraphsByKeys::usage =
  "indexGraphsByKeys[graphs, keys] groups a list of graphs by the specified keys. \n\
keys is a list of property names (e.g. {\"vertexcount\", \"edgecount\", \"leafcount\"}). \n\
For each graph, the corresponding property values are collected (using built-in\n\
vertexcount, edgecount and the provided leafCount function) and GroupBy is used to \n\
return an association whose keys are lists of these property values and whose\n\
values are lists of graphs.";

aggregateIndex::usage =
  "aggregateIndex[grouped, conds] aggregates groups from an association (as returned\n\
by indexGraphsByKeys) based on conditions. conds is a list of {min, max} ranges, one\n\
per key. Only groups whose key (a list of numbers) satisfies Between for each\n\
element are returned.";

twoterminalgraphq::usage =
  "twoterminalgraphq[g] tests whether the graph g has exactly two leaf (terminal)\n\
nodes and whether every internal node lies on at least one simple path between\n\
the two terminals. This ensures that any two-terminal network represented by g\n\
has no 'dangling' subtrees, which do not affect the driving point impedance.";

exportIndexedSubsets::usage =
  "exportIndexedSubsets[indexed, outDir, keysLabels] exports each bucket in the\n\
grouped association (e.g. output of indexGraphsByKeys) to a Graph6 file in outDir.\n\
File names are generated from the grouping key. If keysLabels is provided (a list of\n\
property names), the file name will be of the form \"v5_e7_l2.g6\" (using the first\n\
letter of each key, in lower case, and the corresponding value). If keysLabels is\n\
omitted, the file name is built by joining the key values with underscores. This\n\
follows a terse naming convention similar to nauty.";

countBuckets::usage =
  "countBuckets[grouped] returns an association with the same keys as the input\n\
grouped association (from indexGraphsByKeys or aggregateIndex), but with each\n\
bucket replaced by the count (Length) of the graphs in that bucket.";

leafCount::usage =
  "leafCount[graph] returns the number of leaf nodes (vertices with degree 1) in\n\
the graph.";

Begin["`Private`"]

(* 1. importG6Files: Import *.g6 files from a directory. *)
importG6Files[dir_String, pattern_String:"*.g6"] := Module[{files},
  files = FileNames[pattern, dir, Infinity];
  AssociationThread[
    FileBaseName /@ files,
    Import /@ files
  ]
];

(* 2. leafCount: Count vertices of degree 1. *)
leafCount[graph_] :=
  Count[VertexList[graph], v_ /; VertexDegree[graph, v] == 1];

(* 3. indexGraphsByKeys: Group graphs by a combination of properties.
   Allowed keys (currently): "vertexcount", "edgecount", "leafcount". *)
indexGraphsByKeys[graphs_List, keys_List] := Module[{keyFunc},
  keyFunc[graph_] := (Switch[#, 
      "vertexcount", VertexCount[graph],
      "edgecount", EdgeCount[graph],
      "leafcount", leafCount[graph],
      _, Missing["unknownkey"]
    ] & /@ keys);
  GroupBy[graphs, keyFunc]
];

(* 4. aggregateIndex: Select groups whose key (a list of numbers) falls within
   the given ranges. conds should be a list of {min, max} pairs, one per property. *)
aggregateIndex[grouped_Association, conds_List] := Module[
  {keySelectFunction},
  keySelectFunction[k_?ListQ] := And @@ MapThread[Between, {k, conds}];
  KeySelect[grouped, keySelectFunction]
];

(* 5. countBuckets: Count the number of graphs in each bucket of a grouped
   association. *)
countBuckets[grouped_Association] :=
  AssociationThread[Keys[grouped], Map[Length, Values[grouped]]];

(* 6. onPathBetweenTerminalsQ: Check if vertex v lies on at least one simple
   path from t1 to t2 in graph g. *)
onPathBetweenTerminalsQ[g_, v_, t1_, t2_] := Module[{paths},
  paths = FindPath[g, t1, t2];
  Or @@ (MemberQ[#, v] & /@ paths)
];

(* 7. twoterminalgraphq: Return True if g has exactly two leaves and every
   internal vertex lies on at least one simple t1-t2 path. *)
twoterminalgraphq[g_] := Module[{leaves, t1, t2, internals},
  leaves = Select[VertexList[g], VertexDegree[g, #] == 1 &];
  If[Length[leaves] != 2, Return[False]];
  {t1, t2} = leaves;
  internals = Complement[VertexList[g], {t1, t2}];
  And @@ (onPathBetweenTerminalsQ[g, #, t1, t2] & /@ internals)
];

(* 8. keyToFileName: Given a grouping key and corresponding property names, 
   produce a terse file name. For example, with keysLabels
   {\"vertexcount\", \"edgecount\", \"leafcount\"} and key {5,7,2}, returns
   \"v5_e7_l2.g6\". *)
keyToFileName[key_List, keysLabels_List] :=
  StringJoin @@ Riffle[
    MapThread[(ToLowerCase[StringTake[#1, 1]] <> ToString[#2]) &,
      {keysLabels, key}],
    "_"
  ] <> ".g6";

(* Overloaded helper: If no keysLabels are provided, join the key values with
   underscores. *)
keyToFileName[key_List] :=
  StringJoin @@ Riffle[ToString /@ key, "_"] <> ".g6";

(* 9. exportIndexedSubsets: Export each bucket (group) from an indexed association
   (as produced by indexGraphsByKeys) to a Graph6 file in outDir. If keysLabels
   is provided, use it to build the file name. *)
exportIndexedSubsets[indexed_Association, outDir_String, 
   keysLabels_: {}] := Module[{fileName, filePath},
  If[!DirectoryQ[outDir],
    CreateDirectory[outDir, CreateIntermediateDirectories -> True]
  ];
  Scan[
    Function[r,
      With[{groupKey = First[r], graphs = Last[r]},
        fileName = If[keysLabels === {},
          keyToFileName[groupKey],
          keyToFileName[groupKey, keysLabels]
        ];
        filePath = FileNameJoin[{outDir, fileName}];
        Export[filePath, graphs, "Graph6"]
      ]
    ],
    Normal[indexed]
  ];
  "export completed."
];

End[]  (* `Private` *)

EndPackage[]
