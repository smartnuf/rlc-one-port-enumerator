function bar_kit_counts( kit_counts )
%bar_kits Creates a bar graph on the current figure
%   Detailed explanation goes here
    h = bar( kit_counts.rlc_count, kit_counts.kit_count );
    grid on;
    xlabel( 'rlc count' );
    ylabel( 'kit count' );
end
