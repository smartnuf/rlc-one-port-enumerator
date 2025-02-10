% A triangle
g1 = graph( [ 1 2 3 ], [ 3 1 2 ] );

d11 = designate_terminal_pair( g1, [ 1 2 ] );
d12 = designate_terminal_pair( g1, [ 2 3 ] );
d13 = designate_terminal_pair( g1, [ 1 3 ] );

assert( ~ is_a_distinct_two_terminal_graph( d11, { d12, d13 } ), "0" );

% A 'Y'
g2 = graph( [ 1 2 3 ], [ 4 4 4 ] );
d21 = designate_terminal_pair( g2, [ 1 2 ] );
d22 = designate_terminal_pair( g2, [ 1 4 ] );
d23 = designate_terminal_pair( g2, [ 2 3 ] );
d24 = designate_terminal_pair( g2, [ 2 4 ] );

assert( is_a_distinct_two_terminal_graph( d21, { d24 } ),     "1" );
assert( is_a_distinct_two_terminal_graph( d21, { d22 d24 } ), "2" );
assert( ~is_a_distinct_two_terminal_graph( d22, { d24 } ),    "3" );
assert( ~is_a_distinct_two_terminal_graph( d21, { d23 } ),    "4" );
