% There are 3 component types
num_component_types = 3;
% There are 2^3 - 1 = 7 distinct branch types
num_edge_types = 2 ^ num_component_types - 1;
% There are 7 ^ max_ne distinct sets of edges
num_distinct_sets_of_typed_edges = @( max_ne ) num_edge_types ^ max_ne;
% One question : how many distinct sets of of edges are there with with
% a given set of nr reistors, nl inductors, and nc capacitors?
% There are 
% For a network of up to max_ne edges there are up to 
% max_nv = 1 + max_ne verticies
max_num_verticies = @( max_ne ) 1 + max_ne;
% Are 
% There are nv * ( nv - 1 ) ways to choose two vertices for a first edge
% There are nv * ( nv - 2 ) ways to choose two vertices for a second edge
% ... ne edges
% There sum( nv * ( nv - ( 1 : ne ) ) ) ways to choose to vertices for ne
% edges for an underlying graph stucture of ne edges
num_graphs_of_num_edes = @( ne ) sum( ( 1 + ne ) * ( 1 : ne ) ) / 2;
num_graphs_of_up_to_max_num_edges = @( max_ne ) sum( num_graphs_of_num_edes( max_ne ) );
% But is a choice of among 8 edge_types for each of ne edges for each graph
% ( 1 + ne ) * ne ) / 2 edges
% This is 9 ^ ( ( 1 + max_ne ) * max_ne ) / 2 )
% num_labelled_graphs = @( max_ne ) 9 ^ ( ( 1 + max_ne ) * max_ne / 2 );
num_distinct_sets_of_labelled_edges = @( max_ne ) num_edge_types ^ max_ne;
