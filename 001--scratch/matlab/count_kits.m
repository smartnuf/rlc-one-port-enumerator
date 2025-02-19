function kit_counts = count_kits( rlc_store )
    %  count_kits Computes counts of distinct component kits (sets).
    %   kits = kit_count( rlc_store  ) computes the number
    %   of distinct sets of n components drawn from source sets with
    %   0 to NR R, 0 to NL L, and 0 to NC C components.
    %
    %   Input:
    %       rlc_store - a vector [ NR, NL, NC ] specifying maximum 
    %                   available number of components for types 
    %                   R, L, and C, respectively.
    %
    %   Output:
    %       kits - a table with columns 'rlc_count' and 'kit_count' for
    %              n = 1 to sum( rlc_store ).
    
    rlc_store = rlc_store( : );
    K = length( rlc_store );
    assert( K == 3, "'rlc_store should' be a vector of 3 elements" );
    % Generate polynomials for each component type.
    % For each type the generating function is 1 + x + ... + x^(N).
    poly_r = ones( 1, rlc_store( 1 ) + 1 );
    poly_l = ones( 1, rlc_store( 2 ) + 1 );
    poly_c = ones( 1, rlc_store( 3 ) + 1 );
    
    % Compute overall generating function by convolution.
    % poly_total(k+1) is the coefficient for x^k.
    poly_total = conv( poly_r, conv( poly_l, poly_c ) );
    
    % Maximum number of components that can be drawn.
    n_max = sum( rlc_store );
    
    % Build table for n = 1 to n_max (omit n = 0 term).
    n_values = ( 1 : n_max )';
    coefficients = poly_total( 2 : end )';  % Skip the x^0 term.
    kit_counts = ...
    table...
    ( ...
        n_values, ...
        coefficients, ...
        'VariableNames', ...
        { 'rlc_count', 'kit_count' } ...
    );
end
