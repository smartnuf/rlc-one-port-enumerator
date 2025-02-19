M1 = 1; M2 = 5;      % min, max number of edges
N1 = 2; N2 = M2 + 1; % min, max number of nodes
tic
gen_unique_two_terminal_graphs( N1, N2, M1, M2 )
toc
