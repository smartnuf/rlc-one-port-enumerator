function rlc_kits = gen_rlc_kits( rlc_store )
    % gen_rlc_kits Generate all selectable rlc component sets (kits).
    %   rlc_kits = gen_rlc_kits( rlc_store ) returns a matrix with
    %   each row representing a set descriptor [ KR, KL, KC ], where
    %   rlc_store = [ NR, NL, NC ] specifies the maximum available 
    %   mumber of components for R, L, and C, respectively. 
    %   The empty set (0,0,0) is omitted.
    %
    %   Example:
    %       rlc_store = [ 3, 1, 1 ];
    %       rlc_kits = gen_rlc_kitss( rlc_store );
    %       % Returns a 15 x 3 matrix.
    
    % Extract maximum counts for each component type.
    NR = rlc_store( 1 );
    NL = rlc_store( 2 );
    NC = rlc_store( 3 );
    
    % Create grids for each count using ndgrid.
    [ kr, kl, kc ] = ndgrid( 0 : NR, 0 : NL, 0 : NC );
    
    % Reshape the grids into column vectors.
    kr = kr( : );
    kl = kl( : );
    kc = kc( : );
    
    % Combine into a matrix where each row is [KR, KL, KC].
    rlc_kits = [ kr, kl, kc ];
    
    % Remove the empty set (0,0,0).
    empty_set = ( rlc_kits( :, 1 ) == 0 ) & ( rlc_kits( :, 2 ) == 0 ) & ( rlc_kits( :, 3 ) == 0 );
    rlc_kits( empty_set, : ) = [ ];
end
