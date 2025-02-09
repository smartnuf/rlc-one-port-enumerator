function g = connected_simple_graphs_by_num_edges( num_edges )
%SIMPLE_GRAPHS_BY_NUM_EDGES
%   Simple graphs are graphs with no single virtex loops and with no two
%   edges share the same vertices. Connected graphs are those for which
%   there exists at least one path between all vertices
    g = cell( 0, 1 );
    for ne = num_edges
        % We must have at least 2 nodes and at most 1 more than the number
        % of edges (if the graph is to be connected).
        for nv = 2 : 1 + ne
            % List all possible distict edges
            possible_edge_vertex_pairs = nchoosek( 1 : nv, 2 );
            num_possible_edges = size( possible_edge_vertex_pairs, 1 );
            % if we have enough possible edges
            if num_possible_edges >= ne
                % List all possible sets of ne possible_edges
                candidate_graph_edge_idx_sets = nchoosek( 1 : num_possible_edges, ne );
                num_candidate_graphs = size( candidate_graph_edge_idx_sets, 1 );
                for candidate_graph_idx = 1 : num_candidate_graphs
                    candidate_graph_edge_idx_set = candidate_graph_edge_idx_sets( candidate_graph_idx, : )';
                    candidate_graph_vertex_pairs = possible_edge_vertex_pairs( candidate_graph_edge_idx_set, : );
                    % Create a built-in graph type from the edge pairs
                    candidate_graph = graph( candidate_graph_vertex_pairs( :, 1 ), candidate_graph_vertex_pairs( :, 2 ) );
                    % if the candidate graph is connected
                    if all( conncomp( candidate_graph ) == 1 )
                        % All the vertices are in bin 1, 
                        % if it is not isomorphic to an existing graph
                        is_distinct = true;
                        for i = 1 : length( g )
                            if isisomorphic( candidate_graph, g{ i } )
                                is_distinct = false;
                                break
                            end
                        end
                        if is_distinct
                            % append it to g
                            g{ end + 1, 1 } = candidate_graph;
                        end
                    end
                end
            end
        end
    end
end
