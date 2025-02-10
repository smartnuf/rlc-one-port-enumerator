function o_graphs = distinct_designations_of_two_terminal_nodes( i_graphs )
%DISTINCT_DESIGNATIONS_OF_TWO_TERMINAL_NODES
%   i_graphs - Input graphs to have two nodes designated as terminal 
%   (port) nodes.
    % We accept a cell array of graphs of any dimensions, but process
    % as a one-demensionals cell array
    i_graphs = i_graphs( : );
    num_graphs = length( i_graphs );
    o_graphs = cell( 0, 1 );
    for i = 1 : num_graphs
        base_graph = i_graphs{ i };
        base_graph_degree = degree( base_graph );
        base_graph_leaf_nodes = find( base_graph_degree == 1 );
        base_graph_num_leaves = length( base_graph_leaf_nodes );
        base_graph_num_nodes = numnodes( base_graph );
        candidate_terminal_pairs = zeros( 0, 2 );
        if base_graph_num_leaves > 2 
            % There are 3 or more leaf nodes and there is no way to
            % designate two terminals without leaving at least one remaing
            % leaf. That would mean there would necessarily be a redundant 
            % edge (branch), and hence the two terinal network would have 
            % equivalence to a two terminal network with with fewer
            % edges (branches). So we ignore this base graph entirely.
        elseif base_graph_num_leaves == 2
            % The only non-redundant two-terminal network we can construct
            % must have have the 2 leaf nodes as terminals.
            candidate_terminal_pairs = base_graph_leaf_nodes';
        elseif base_graph_num_leaves == 1
            % One of the terminals must be the leaf node, and we choose
            % the other from the remaining set
            terminal_1 = base_graph_leaf_nodes;
            terminal_2 = [ ( 1 : terminal_1 - 1 )';
                           ( terminal_1 + 1 : numnodes( base_graph ) )' ];
            terminal_1 = repmat( terminal_1, [ base_graph_num_nodes - 1, 1 ] );
            candidate_terminal_pairs = [ terminal_1, terminal_2 ];
        else
            % We do not need to bind any terminal to a leaf node
            candidate_terminal_pairs = nchoosek( 1 : base_graph_num_nodes, 2 );
        end
        % n x 2 array of node numbers
        num_candidate_terminal_pairs = size( candidate_terminal_pairs, 1 );
        % Decorate with graph.Nodes.Terminal
        if num_candidate_terminal_pairs > 0
            two_terminal_graphs = cell( 0, 1 );
            for j = 1 : num_candidate_terminal_pairs
                candidate_two_terminal_graph = ...
                designate_terminal_pair...
                ( ...
                    base_graph, ...
                    candidate_terminal_pairs( j, : ) ...
                );
                if is_a_distinct_two_terminal_graph...
                   ( ...
                       candidate_two_terminal_graph, ...
                       two_terminal_graphs ...
                   )
                   two_terminal_graphs{ 1 + end, 1 } = candidate_two_terminal_graph; %#ok<AGROW> 
                   o_graphs{ 1 + end, 1 } = candidate_two_terminal_graph; %#ok<AGROW> 
                end
            end
        end
    end
end
