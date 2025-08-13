# basic_graphs_check.py
import subprocess, itertools
import networkx as nx
import pynauty

def geng_connected(n):
    p = subprocess.Popen(["geng","-cq",str(n)], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    for line in p.stdout: yield line.strip()

def g6_to_nx(g6): return nx.from_graph6_bytes(g6)

def unordered_pairs(nodes):
    for i in range(len(nodes)):
        for j in range(i+1,len(nodes)):
            yield nodes[i], nodes[j]

def edge_on_st_path(G, e, s, t):
    u, v = e
    H = G.copy()
    H.remove_edge(u, v)
    def has(a,b): 
        try: nx.shortest_path(H,a,b); return True
        except nx.NetworkXNoPath: return False
    return (has(s,u) and has(v,t)) or (has(s,v) and has(u,t))

def is_basic_for_terminals(G, s, t):
    return all(edge_on_st_path(G, e, s, t) for e in G.edges())

def canon_two_terminal(G, s, t):
    # relabel vertices 0..n-1
    mapping = {v:i for i,v in enumerate(G.nodes())}
    n = len(mapping)
    adj = [[] for _ in range(n)]
    for u,v in G.edges():
        ui, vi = mapping[u], mapping[v]
        adj[ui].append(vi); adj[vi].append(ui)
    g = pynauty.Graph(number_of_vertices=n, directed=False)
    for i in range(n):
        if adj[i]: g.connect_vertex(i, sorted(set(adj[i])))
    S, T = mapping[s], mapping[t]
    # terminals as a color class (unordered), others in another
    others = set(range(n)) - {S,T}
    g.set_vertex_coloring([set([S,T]), others])
    return pynauty.certificate(g)

def count_basic_graphs(E):
    seen = set()
    for n in range(2, E+2):                      # n can be 2..E+1
        for g6 in geng_connected(n):
            G = g6_to_nx(g6)
            if G.number_of_edges() != E: continue
            for s,t in unordered_pairs(list(G.nodes())):
                if not is_basic_for_terminals(G, s, t): 
                    continue
                cert = canon_two_terminal(G, s, t)
                seen.add(cert)
    return len(seen)

if __name__ == "__main__":
    for E in range(1,6):
        print(E, count_basic_graphs(E))
