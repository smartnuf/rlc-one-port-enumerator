load( "data/g.mat" );
load( "data/h.mat" );
load( "data/cg.mat" );
load( "data/ch.mat" );

assert( all( count_graphs_by_num_nodes_and_edges( g ) == cg, 'all' ), "Fail cg" );
assert( all( count_graphs_by_num_nodes_and_edges( h ) == ch, 'all' ), "Fail ch" );

%save data/cg.mat cg
%save save/ch.mat ch

sum_cg_e = sum( cg )
sum_cg_v = sum( cg, 2 )
sum_sum_cg = sum( sum_cg_e )
nvg = ( 1 : size( cg, 1 ) )';
neg = ( 0 : size( cg, 2 ) );
acg = [ neg; [ nvg, cg ] ]

sum_ch_e = sum( ch )
sum_ch_v = sum( ch, 2 )
sum_sum_ch = sum( sum_ch_e )
nvh = ( 1 : size( ch, 1 ) )';
neh = ( 0 : size( ch, 2 ) );
ach = [ neh; [ nvh, ch ] ]
