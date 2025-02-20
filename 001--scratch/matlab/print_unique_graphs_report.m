function print_unique_graphs_report( unique_graphs, N1, N2, M1, M2 )
    % This function prints a summary report of the unique graphs produced by
    % gen_unique_two_terminal_core_graphs.
    %
    % The input 'unique_graphs' is a cell array of structures. Each structure must have fields:
    %   - G : The MATLAB graph object.
    %   - N : The number of nodes in the graph.
    %   - M : The number of edges in the graph.
    %
    % N1, N2, M1, M2 are the parameters used to generate the graphs.
    
    % Create a counts matrix where rows correspond to node counts (N1 to N2)
    % and columns correspond to edge counts (M1 to M2).
    unique_graph_counts = zeros( N2 - N1 + 1, M2 - M1 + 1 );
    
    for i = 1 : length( unique_graphs )
        N_val = unique_graphs{ i }.N;
        M_val = unique_graphs{ i }.M;
        unique_graph_counts( N_val - N1 + 1, M_val - M1 + 1 ) = ...
            unique_graph_counts( N_val - N1 + 1, M_val - M1 + 1 ) + 1;
    end
    
    % Compute row and column totals.
    row_totals = sum( unique_graph_counts, 2 );
    column_totals = sum( unique_graph_counts, 1 );
    
    % Print the summary report.
    fprintf( 'Number of unique two-terminal core graphs with %d to %d nodes and %d to %d edges:\n', N1, N2, M1, M2 );
    fprintf( 'N\\E\t' );
    for M = M1 : M2
        fprintf( '%d\t', M );
    end
    fprintf( 'Tot\n' );
    for N = N1 : N2
        fprintf( '%d\t', N );
        for M = M1 : M2
            fprintf( '%d\t', unique_graph_counts( N - N1 + 1, M - M1 + 1 ) );
        end
        fprintf( '%d\n', row_totals( N - N1 + 1 ) );
    end
    fprintf( 'Tot\t' );
    for total = column_totals
        fprintf( '%d\t', total );
    end
    fprintf( '%d\n', sum( column_totals ) );
end
