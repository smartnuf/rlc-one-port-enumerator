g1 = connected_simple_graphs_by_num_edges( 1 );
g2 = connected_simple_graphs_by_num_edges( 2 );
g3 = connected_simple_graphs_by_num_edges( 3 );
g4 = connected_simple_graphs_by_num_edges( 4 );
g5 = connected_simple_graphs_by_num_edges( 5 );
g1_5 = connected_simple_graphs_by_num_edges( 1 : 5 );

c1 = count_graphs_by_num_nodes_and_edges( g1 );
c2 = count_graphs_by_num_nodes_and_edges( g2 );
c3 = count_graphs_by_num_nodes_and_edges( g3 );
c4 = count_graphs_by_num_nodes_and_edges( g4 );
c5 = count_graphs_by_num_nodes_and_edges( g5 );
c1_5 = count_graphs_by_num_nodes_and_edges( g1_5 );

c1_5_nauthy = ...
[
     0     0     0     0     0;
     1     0     0     0     0;
     0     1     1     0     0;
     0     0     2     2     1;
     0     0     0     3     5;
     0     0     0     0     6;   
];

assert( all( c1_5 == c1_5_nauthy, [ 1, 2 ] ), "Fail, nauty disagrees" );

fprintf( "test_1 OK\n" );
