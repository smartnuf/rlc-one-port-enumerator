function unique_graphs = gen_unique_two_terminal_core_graphs( N1, N2, M1, M2 )
    % This function generates non-isomorphic connected simple graphs with N1 to N2 nodes 
    % and M1 to M2 edges.
    % Nodes 1 and 2 are treated as terminal nodes, and node labels are used in isomorphism tests.
    % Only graphs in which every non-terminal node lies on at least one simple path between
    % nodes 1 and 2 are collected (i.e. graphs without dangling branches).
    %
    % Graphs with different sorted degree sequences cannot be isomorphic, so we immediately 
    % separate them by using the sorted degree sequence as a classification invariant.
    % This reduces the number of expensive isomorphism tests.
    %
    % The function returns a cell array where each element is a struct with fields:
    %   - G : The MATLAB graph object.
    %   - N : The number of nodes in the graph.
    %   - M : The number of edges in the graph.
    
    % Global container for all unique graphs (with classification info)
    all_unique_graphs = { };
    
    % Generate graphs for each number of nodes from N1 to N2.
    for N = N1 : N2
        % For each number of edges from M1 to M2.
        for M = M1 : M2
            % Generate all possible combinations of edges (for a complete graph on N nodes)
            edges = nchoosek( 1 : N, 2 );
            num_edges = size( edges, 1 );
            
            % Initialize a containers.Map for invariants.
            % Each key is a string invariant; each value is a cell array of graphs.
            invariant_map = containers.Map( 'KeyType', 'char', 'ValueType', 'any' );
            
            if ( M <= num_edges )
                % Iterate over all possible subsets of edges of size M.
                combinations = nchoosek( 1 : num_edges, M );
                for i = 1 : size( combinations, 1 )
                    edge_subset = edges( combinations( i, : ), : );
                    
                    % Create the adjacency matrix.
                    adj_matrix = zeros( N );
                    for j = 1 : M
                        adj_matrix( edge_subset( j, 1 ), edge_subset( j, 2 ) ) = 1;
                        adj_matrix( edge_subset( j, 2 ), edge_subset( j, 1 ) ) = 1;
                    end
                    
                    % Create the graph from the adjacency matrix.
                    G = graph( adj_matrix );
                    
                    % Assign node labels: nodes 1 and 2 are 'Terminal'; others are 'NonTerminal'.
                    labels = cell( N, 1 );
                    labels{ 1 } = 'Terminal';
                    if ( N >= 2 )
                        labels{ 2 } = 'Terminal';
                    end
                    for k = 3 : N
                        labels{ k } = 'NonTerminal';
                    end
                    G.Nodes.Label = labels;
                    
                    % Check if the graph is connected.
                    if ( all( conncomp( G ) == 1 ) )
                        % For every internal node (nodes 3 to N), verify there is at least one simple 
                        % path from node 1 to node 2 that passes through that node.
                        skip_graph = false;
                        for v = 3 : N
                            if ( ~ has_path_through( G, v ) )
                                skip_graph = true;
                                break;
                            end
                        end
                        
                        if ( skip_graph )
                            continue;
                        end
                        
                        % Compute an invariant for classification (sorted degree sequence).
                        key = get_invariant( G );
                        
                        % Use invariant_map to avoid unnecessary isomorphism tests.
                        if ( ~ isKey( invariant_map, key ) )
                            invariant_map( key ) = { G };
                        else
                            bucket = invariant_map( key );
                            is_unique = true;
                            for k = 1 : length( bucket )
                                if ( isisomorphic( G, bucket{ k }, 'NodeVariables', { 'Label' } ) )
                                    is_unique = false;
                                    break;
                                end
                            end
                            if ( is_unique )
                                bucket{ end + 1 } = G;
                                invariant_map( key ) = bucket;
                            end
                        end
                    end
                end
            end
            
            % Combine graphs from all invariant buckets.
            unique_graphs_current = { };
            keys_list = keys( invariant_map );
            for k = 1 : length( keys_list )
                bucket = invariant_map( keys_list{ k } );
                unique_graphs_current = [ unique_graphs_current, bucket ]; %#ok<AGROW>
            end
            
            % Append each graph (with its classification info) to the overall list.
            for idx = 1 : length( unique_graphs_current )
                all_unique_graphs{ end + 1 } = struct( 'G', unique_graphs_current{ idx }, 'N', N, 'M', M );
            end
        end
    end
    
    % Return the aggregated unique graphs with classification info.
    unique_graphs = all_unique_graphs;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nested helper function that checks if there exists at least one simple path 
% from node 1 to node 2 that passes through a given internal node v.
function flag = has_path_through( G, v )
    % Uses a DFS search starting at node 1 to look for node 2 while tracking
    % whether node v is encountered along the current path.
    N_nodes = numnodes( G );
    visited = false( 1, N_nodes );
    visited( 1 ) = true;
    flag = dfs( 1, false, visited );
    
    function found = dfs( current, passed_v, visited )
        if ( current == v )
            passed_v = true;
        end
        if ( current == 2 )
            found = passed_v;
            return;
        end
        found = false;
        nbrs = neighbors( G, current );
        for idx = 1 : length( nbrs )
            nb = nbrs( idx );
            if ( ~ visited( nb ) )
                visited( nb ) = true;
                if ( dfs( nb, passed_v, visited ) )
                    found = true;
                    return;
                end
                visited( nb ) = false;
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nested helper function to compute a simple invariant for graph classification.
% Here we use the sorted degree sequence as a string.
function key = get_invariant( G )
    d = degree( G );
    key = mat2str( sort( d ) );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
