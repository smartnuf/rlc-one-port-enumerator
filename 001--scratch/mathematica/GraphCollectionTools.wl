(* ::Package:: *)

(* ::Package:: *)

BeginPackage["GraphCollectionTools`"]

ImportG6Files::usage =
  "ImportG6Files[dir, pattern] imports all files matching pattern (default \"*.g6\") from directory dir (and subdirectories) as Graphs in Graph6 format. \
It returns an Association mapping file base names to imported graphs.";

IndexGraphsByKeys::usage =
  "IndexGraphsByKeys[graphs, keys] groups a list of graphs by the specified keys. \
The keys is a list of property names (e.g. {\"VertexCount\", \"EdgeCount\", \"LeafCount\"}). \
For each graph, the corresponding property values are collected (using built\[Hyphen]in VertexCount, EdgeCount and the provided leafCount function) and \
GroupBy is used to return an Association whose keys are lists of these property values and whose values are lists of graphs.";

AggregateIndex::usage =
  "AggregateIndex[grouped, conds] aggregates groups from an association (as returned by IndexGraphsByKeys) based on conditions. \
conds is a list of {min, max} ranges, one per key. Only groups whose key (a list of numbers) satisfies Between for each element are returned.";

ExportIndexedSubsets::usage =
  "ExportIndexedSubsets[indexed, outDir, keysLabels] exports each bucket in the grouped association (such as the output of IndexGraphsByKeys) \
to a Graph6 file in the directory outDir. File names are generated from the grouping key. If keysLabels is provided (a list of property names), \
the file name will be of the form \"v5_e7_l2.g6\" (using the first letter of each key, in lower case, and the corresponding value). \
If keysLabels is omitted, the file name is built by joining the key values with underscores. \
This follows a terse naming convention similar to nauty.";

leafCount::usage =
  "leafCount[graph] returns the number of leaf nodes (vertices with degree 1) in the graph.";

Begin["`Private`"]

(* 1. ImportG6Files: Import *.g6 files from a directory. *)
ImportG6Files[dir_String, pattern_String:"*.g6"] := Module[{files},
  files = FileNames[pattern, dir, Infinity];
  AssociationThread[
    FileBaseName /@ files,
    Import /@ files
  ]
];

(* 2. leafCount: Count vertices of degree 1. *)
leafCount[graph_] := Count[VertexList[graph], v_ /; VertexDegree[graph, v] == 1];

(* 3. IndexGraphsByKeys: Group graphs by a combination of properties.
   Allowed keys (currently): "VertexCount", "EdgeCount", "LeafCount". *)
IndexGraphsByKeys[graphs_List, keys_List] := Module[{keyFunc},
  keyFunc[graph_] := (Switch[#, 
      "VertexCount", VertexCount[graph],
      "EdgeCount", EdgeCount[graph],
      "LeafCount", leafCount[graph],
      _, Missing["UnknownKey"]
    ] & /@ keys);
  GroupBy[graphs, keyFunc]
];

(* 4. AggregateIndex: Select groups whose key (a list of numbers) falls within the given ranges.
   conds should be a list of {min, max} pairs, one per property. *)
AggregateIndex[grouped_Association, conds_List] := Module[{keySelectFunction},
  keySelectFunction[k_?ListQ] := And @@ MapThread[Between, {k, conds}];
  KeySelect[grouped, keySelectFunction]
];

(* Helper: Given a grouping key and corresponding property names, produce a terse file name.
   For example, with keysLabels {"VertexCount","EdgeCount","LeafCount"} and key {5,7,2},
   this returns "v5_e7_l2.g6". *)
keyToFileName[key_List, keysLabels_List] := 
  StringJoin @@ Riffle[
    MapThread[(ToLowerCase[StringTake[#1, 1]] <> ToString[#2]) &, {keysLabels, key}],
    "_"
  ] <> ".g6";

(* Overloaded helper: If no keysLabels are provided, join the key values with underscores. *)
keyToFileName[key_List] := StringJoin @@ Riffle[ToString /@ key, "_"] <> ".g6";

(* 5. ExportIndexedSubsets: Export each bucket (group) from an indexed association (as produced by IndexGraphsByKeys) 
   to a Graph6 file in outDir. If keysLabels is provided, use it to build the file name. *)
ExportIndexedSubsets[indexed_Association, outDir_String, keysLabels_: {}] := Module[
  {fileName, filePath},
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
  "Export completed."
];

End[]  (* `Private` *)

EndPackage[]
