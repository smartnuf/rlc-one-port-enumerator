function generate_nonisomorphic_graphs( N, M, plot )
    % This function generates non-isomorphic connected simple graphs with N nodes and M edges

    % Generate all possible combinations of edges
    edges = combnk( 1 : N, 2 );
    num_edges = size(edges, 1);
    if M > num_edges
        error('Too many edges for the given number of nodes');
    end

    % Initialize a cell array to store the unique graphs
    unique_graphs = {};

    % Iterate over all possible subsets of edges
    combinations = combnk( 1 : num_edges, M );
    for i = 1:size( combinations, 1 )
        edge_subset = edges( combinations( i, : ), : );

        % Create the adjacency matrix
        adj_matrix = zeros( N );
        for j = 1 : M
            adj_matrix( edge_subset( j, 1 ), edge_subset( j, 2 ) ) = 1;
            adj_matrix( edge_subset( j, 2 ), edge_subset( j, 1 ) ) = 1;
        end

        % Check if the graph is connected
        G = graph( adj_matrix );
        if all( conncomp(G) == 1 )
            % Check if the graph is isomorphic to any existing graph in unique_graphs
            is_unique = true;
            for k = 1:length( unique_graphs )
                if isisomorphic( G, unique_graphs{ k } )
                    is_unique = false;
                    break;
                end
            end

            % Add the graph to unique_graphs if it's unique
            if is_unique
                unique_graphs{ end + 1 } = G;
            end
        end
    end

    fprintf...
    ( ...
        "There are %d unique graphs of %d nodes and %d edges\n", ...
        length( unique_graphs ), ...
        N, ...
        M ...
    );
    if nargin > 2    
        % Display the unique graphs
        for i = 1:length( unique_graphs )
            figure;
            plot( unique_graphs{ i } );
            title( sprintf( 'Graph %d', i ) );
        end
    end
end
