% A triangle
g = graph( [ 1 2 3 ], [ 3, 1, 2 ] );
d1 = designate_terminal_pair( g, [ 1 2 ] );
d2 = designate_terminal_pair( g, [ 2 3 ] );
d3 = designate_terminal_pair( g, [ 1 3 ] );

g1_5 = distinct_connected_simple_graphs_by_num_edges( 1 : 5 );
d1_5 = cell( 0, 1 );
for i = 1 : length( g1_5 )
    terminals = nchoosek( 1 : numnodes( g1_5{ i } ), 2 );
    for j = 1 : size( terminals, 1 )
        d = designate_terminal_pair( g1_5{ i }, terminals( j, : ) );
        t = false( numnodes( g1_5{ i } ), 1 );
        t( terminals( j , : ) ) = true;
        assert( all( d.Nodes.Terminal == t ), sprintf( "failed at graph %d, terminal pair %d", i, j ) );
    end
end
