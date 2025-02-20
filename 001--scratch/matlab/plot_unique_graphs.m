function plot_unique_graphs( unique_graphs )
    % This function accepts a cell array of structures produced by 
    % gen_unique_two_terminal_core_graphs. Each structure must have fields:
    %   - G : The MATLAB graph object.
    %   - N : The number of nodes.
    %   - M : The number of edges.
    %
    % The function displays the graphs in subplots arranged in a grid of 4 rows x 5 columns
    % (i.e. up to 20 subplots per figure). Terminal nodes (nodes 1 and 2) are highlighted in red.
    
    num_graphs = length( unique_graphs );
    plots_per_figure = 20;  % 4 rows x 5 columns.
    for idx = 1 : num_graphs
        % Create a new figure for each block of plots_per_figure.
        if ( mod( idx - 1, plots_per_figure ) == 0 )
            figure;
        end
        subplot( 4, 5, mod( idx - 1, plots_per_figure ) + 1 );
        h = plot( unique_graphs{ idx }.G );
        % Highlight terminal nodes (1 and 2) in red.
        highlight( h, [ 1, 2 ], 'NodeColor', 'r' );
        title( sprintf( 'Graph %d (N = %d, M = %d)', idx, unique_graphs{ idx }.N, unique_graphs{ idx }.M ) );
    end
end
