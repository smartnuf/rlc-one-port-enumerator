function is_distinct = is_a_distinct_two_terminal_graph( g, graphs )
% IS_A_DISTINCT_TWO_TERMINAL_GRAPH
%   g - a graph with Edges.Terminal true or false
%   graphs - cell array of graphs with Edges.Terminal true or false
    % We say a graph is distict from a set if it is not isomorphic to any
    % in the set
    graphs = graphs( : );
    is_distinct = true;
    for i = 1 : length( graphs )
        if isisomorphic( g, graphs{i}, 'NodeVariables', 'Terminal' )
            is_distinct = false;
            break;
        end
    end
end