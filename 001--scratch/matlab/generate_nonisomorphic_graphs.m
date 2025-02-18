function generate_nonisomorphic_graphs ( N1, N2, M1, M2, showFigures )
    % This function generates non-isomorphic connected simple graphs with N1 to N2 nodes and M1 to M2 edges
    % If showFigures is not provided, default to false
    if nargin < 5
        showFigures = false;
    end

    % Initialize a matrix to store the counts of unique graphs
    unique_graph_counts = zeros ( N2 - N1 + 1, M2 - M1 + 1 );

    % Generate graphs for each number of nodes from N1 to N2
    for N = N1:N2
        % Generate graphs for each number of edges from M1 to M2
        for M = M1:M2
            % Generate all possible combinations of edges
            edges = nchoosek ( 1:N, 2 );
            num_edges = size ( edges, 1 );

            % Initialize a cell array to store the unique graphs
            unique_graphs = {};

            if M <= num_edges
                % Iterate over all possible subsets of edges
                combinations = nchoosek ( 1:num_edges, M );
                for i = 1:size ( combinations, 1 )
                    edge_subset = edges ( combinations ( i, : ), : );

                    % Create the adjacency matrix
                    adj_matrix = zeros ( N );
                    for j = 1:M
                        adj_matrix ( edge_subset ( j, 1 ), edge_subset ( j, 2 ) ) = 1;
                        adj_matrix ( edge_subset ( j, 2 ), edge_subset ( j, 1 ) ) = 1;
                    end

                    % Check if the graph is connected
                    G = graph ( adj_matrix );
                    if all ( conncomp ( G ) == 1 )
                        % Check if the graph is isomorphic to any existing graph in unique_graphs
                        is_unique = true;
                        for k = 1:length ( unique_graphs )
                            if isisomorphic ( G, unique_graphs { k } )
                                is_unique = false;
                                break;
                            end
                        end

                        % Add the graph to unique_graphs if it's unique
                        if is_unique
                            unique_graphs { end + 1 } = G;
                        end
                    end
                end
            end

            % Store the count of unique graphs
            unique_graph_counts ( N - N1 + 1, M - M1 + 1 ) = length ( unique_graphs );

            % Display the unique graphs if showFigures is true
            if showFigures
                for i = 1:length ( unique_graphs )
                    figure;
                    plot ( unique_graphs { i } );
                    title ( sprintf ( 'Graph %d with %d nodes and %d edges', i, N, M ) );
                end
            end
        end
    end

    % Calculate column totals
    column_totals = sum ( unique_graph_counts, 1 );

    % Calculate row totals
    row_totals = sum ( unique_graph_counts, 2 );

    % Print the statistics
    fprintf ( 'Number of unique graphs with %d to %d nodes and %d to %d edges:\n', N1, N2, M1, M2 );
    fprintf ( 'N\\E\t' );
    for M = M1:M2
        fprintf ( '%d\t', M );
    end
    fprintf ( 'Tot\n' );
    for N = N1:N2
        fprintf ( '%d\t', N );
        for M = M1:M2
            fprintf ( '%d\t', unique_graph_counts ( N - N1 + 1, M - M1 + 1 ) );
        end
        fprintf ( '%d\n', row_totals ( N - N1 + 1 ) );
    end

    % Print column totals
    fprintf ( 'Tot\t' );
    for total = column_totals
        fprintf ( '%d\t', total );
    end
    fprintf ( '%d\n', sum ( column_totals ) );
end
