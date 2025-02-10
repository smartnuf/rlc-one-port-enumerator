function two_terminal_graph = designate_terminal_pair( graph, terminal_node_pair )
%DESIGNATE_TERMINAL_PAIRS
    two_terminal_graph = graph;
    two_terminal_graph.Nodes.Terminal( terminal_node_pair ) = true;
end