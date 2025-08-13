import itertools
import networkx as nx
import pynauty

# ----- enumerate symmetric integer matrices (upper triangle sums to E) -----
def all_multigraphs(n, E):
    """
    Yield MultiGraph G on n nodes (0..n-1) with exactly E edges, loops disallowed,
    allowing parallel edges. Each graph is yielded once (we don't dedup here).
    """
    # upper-triangle index list
    pairs = [(i,j) for i in range(n) for j in range(i+1, n)]
    P = len(pairs)

    def rec(idx, rem, counts):
        if idx == P:
            if rem == 0:
                # build multigraph from counts over pairs
                G = nx.MultiGraph()
                G.add_nodes_from(range(n))
                for k,(i,j) in enumerate(pairs):
                    m = counts[k]
                    for _ in range(m):
                        G.add_edge(i,j)
                # connectivity (ignore multiplicities)
                if nx.is_connected(nx.Graph(G)):
                    yield G
            return
        # assign 0..rem to this pair
        for m in range(rem+1):
            counts[idx] = m
            yield from rec(idx+1, rem-m, counts)
        counts[idx] = 0

    yield from rec(0, E, [0]*P)

# ----- incidence bipartite certificate (handles parallel edges cleanly) -----
def certificate_incidence_bipartite(G: nx.MultiGraph, s: int, t: int) -> str:
    """
    Build a simple bipartite incidence graph:
      - left partition: original vertices (colour A), with terminals {s,t} in a special cell (unordered)
      - right partition: one vertex per edge-copy (colour B), connected to its two endpoints
    Then take a pynauty certificate with that vertex colouring.
    """
    # map each edge copy to an "edge vertex" id starting after the original vertices
    n = G.number_of_nodes()
    edge_vertices = []
    for u,v,key in G.edges(keys=True):
        edge_vertices.append((u,v,key))
    m = len(edge_vertices)

    N = n + m
    adj = [[] for _ in range(N)]

    # connect incidence
    # edge vertex ids: n + idx
    for idx,(u,v,key) in enumerate(edge_vertices):
        ev = n + idx
        adj[u].append(ev); adj[v].append(ev)
        adj[ev].append(u); adj[ev].append(v)

    # make pynauty graph
    g = pynauty.Graph(number_of_vertices=N, directed=False)
    for i in range(N):
        if adj[i]:
            g.connect_vertex(i, sorted(set(adj[i])))

    # colouring/partition:
    #   cell0 = {s,t}  (unordered terminals)
    #   cell1 = other original vertices
    #   cell2 = all edge-vertices
    verts = set(range(n))
    cell0 = set([s,t])
    cell1 = verts - cell0
    cell2 = set(range(n, N))
    partition = [cell0, cell1, cell2]
    g.set_vertex_coloring(partition)
    return pynauty.certificate(g)

# ----- "basic" test: every edge-copy lies on some simple s–t path -----
def edge_copy_on_st_path(G: nx.MultiGraph, s: int, t: int, u: int, v: int, key) -> bool:
    """
    Exact: e=(u,v,key) lies on some simple s–t path iff the incidence graph B has
    a simple s->t path that goes through the unique edge-vertex x_e.
    """
    # Build incidence graph B
    n = G.number_of_nodes()
    edge_list = list(G.edges(keys=True))
    m = len(edge_list)
    x_index = {edge_list[i]: n + i for i in range(m)}  # edge-copy -> its x_e vertex id

    B = nx.Graph()
    B.add_nodes_from(range(n + m))
    for (a, b, k2) in edge_list:
        xe = x_index[(a, b, k2)]
        B.add_edge(a, xe)
        B.add_edge(b, xe)

    xe = x_index[(u, v, key)]
    # Enumerate simple s->t paths and check if any contains xe
    # Max length is 2*m+1 (alternates vertex, edge, ...), so set a safe cutoff
    for path in nx.all_simple_paths(B, s, t, cutoff=2 * m + 1):
        if xe in path:
            return True
    return False

def is_basic_for_terminals(G: nx.MultiGraph, s: int, t: int) -> bool:
    for (u,v,k) in G.edges(keys=True):
        if not edge_copy_on_st_path(G, s, t, u, v, k):
            return False
    return True

# ----- main count -----
def count_basic_multigraphs(E: int) -> int:
    seen = set()
    for n in range(2, E+2):  # n can be 2..E+1
        for G in all_multigraphs(n, E):
            nodes = list(G.nodes())
            for i in range(len(nodes)):
                for j in range(i+1, len(nodes)):
                    s, t = nodes[i], nodes[j]
                    if not is_basic_for_terminals(G, s, t):
                        continue
                    cert = certificate_incidence_bipartite(G, s, t)
                    seen.add(cert)
    return len(seen)

if __name__ == "__main__":
    for E in range(1, 6):
        print(E, count_basic_multigraphs(E))
