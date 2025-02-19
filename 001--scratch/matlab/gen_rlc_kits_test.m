load data/rlc_kits_3_1_1_ref.mat
rlc_kits_3_1_1 = gen_rlc_kits( [ 3, 1, 1 ] );
ok = rlc_kits_3_1_1 == rlc_kits_3_1_1_ref;
assert( all( ok, 'all' ), "Unexpected result" );
fprintf( "All ok\n" );
