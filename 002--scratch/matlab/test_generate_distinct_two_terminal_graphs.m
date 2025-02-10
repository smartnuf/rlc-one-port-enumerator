% A 'Y' graph is all leaves -- it has no non-redundant two terminal pair
gy = graph( [ 1 2 3 ], [ 4 4 4 ] );
hy = generate_distinct_two_terminal_graphs( { gy } );
assert( isempty( hy ) );

% A triangle graph has no leaves -- and so has 3 possible two terminal pairs
% only one of which is distinct.
gt = graph( [ 1 2 3 ], [ 2 3 1 ] );
ht = generate_distinct_two_terminal_graphs( { gt } );
assert( length( ht ) == 1, "Fail 1" );

% A square
% Has 6 possible two terminal pairs, of which 2 are distinct
gq = graph( [ 1 2 3 4 ], [ 2 3 4 1 ] );
hq = generate_distinct_two_terminal_graphs( { gq } );
assert( length( hq ) == 2, "Fail 2" );

% A triangular spoked wheel 
% has 6 possible terminal pairs, of which 2 are distinct
gw = graph( [ 1 2 3 1 2 3 ], [ 2 3 1 4 4 4 ] );
hw = generate_distinct_two_terminal_graphs( { gw } );
assert( length( hq ) == 2, "Fail 3" );
