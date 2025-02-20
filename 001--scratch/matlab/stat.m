n1 = [ 6    7   8     9 ]; 
t1 = [ 2.4 36 843 18694 ];
k1 = [ 18  45 125   383 ];
n2 = [ 6    7   8 ];
t2 = [ 2.3 34 747 ];
k2 = [ 18  45 125 ];

figure;
loglog                ...
(                     ...
    n1, t1, 'o-',     ...
    n2, t2, 'o-',     ...
    n1, k1, 'o-',     ...
    'LineWidth', 1.5  ...
); 
grid on;
xlabel( "node count (#)" );
ylabel( "stat ( s, s, # )" );
legend( "runtime(1)", "runtime(optimised)", "graph count", "Location", "northwest" );

