function c = count_graphs_by_num_nodes_and_edges( graphs )
%COUNT_GRAPHS_BY_NUM_NODES_AND_EDGES Summary of this function goes here
%   graphs -- a cell array of graph objects
    graphs = graphs( : );
    num_graphs = length( graphs );
    num_nodes = zeros( num_graphs, 1 );
    num_edges = zeros( num_graphs, 1 );
    for i = 1 : num_graphs
        num_nodes( i ) = height( graphs{ i }.Nodes );
        num_edges( i ) = height( graphs{ i }.Edges );
    end
    c = zeros( max( num_nodes ), max( num_edges ) );
    for i = 1 : num_graphs
        nni = num_nodes( i );
        nei = num_edges( i );
        c( nni, nei ) = 1 + c( nni, nei ); 
    end
end