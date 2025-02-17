function solSet = EnumerateNetworks( vertices, edges, nextVertex, remainingComponents, is_for_new_node )
    % vertices: vector of vertex labels (e.g. [1 2 ...])
    % edges: cell array of edges, each is {v, w, type} with type a char ('R','L','C')
    % nextVertex: integer label for the next new vertex
    % remainingComponents: structure with fields R, L, C (max allowed counts)
    % is_for_new_node - the last branch added is dangaling, or is a
    %                   an unconnected node.
    % solSet: a cell array collecting complete networks (here, every connected network)

    % A first implementation suggested by ChatGPT -- using a recursive 
    % depth-first algorithm.
    % 
    % But is not correct, it adds networks with dangling branches to the 
    % solution set -- it shouldn't of course.
    %
    % It is hidously inefficient -- taking 0.5 seconds to enumerate 111
    % networks from { nR, nL, nC } = { 1, 1, 1 } (a grand total of 3
    % components).
    %
    % I'll refactor to make it readable...
%    disp( vertices); 
%    for i = 1 : length( edges )
%        disp( edges{i} );
%    end
%    disp( nextVertex );
%    disp( remainingComponents );
%    disp( is_for_new_node );

    solSet = {};
    

    if isempty( edges ) || is_for_new_node
        % We won't add it to the solution set anyway, so we needn't
        % check connectivity
    else 
        % Check connectivity: build an undirected graph ignoring labels
        edgePairs = cell2mat(cellfun(@(e) sort([e{1}, e{2}]), edges, 'UniformOutput', false));
        G = graph(edgePairs(:,1), edgePairs(:,2));
        isConnected = all(conncomp(G)==1);
        % We know the node is connected without testing
        if ~ isConnected
%           assert( isConnected, "Unexpected floating node" );
        else
            solSet{end+1,1} = struct('vertices', vertices, 'edges', {edges});
        end
    end
    
    % Generate candidate new edges.
    candidateEdges = {};
    % Case 1: between two existing vertices (i < j)
    nV = length(vertices);
    for i = 1:nV
        for j = i+1:nV
            for comp = ['R','L','C']
                candidateEdges{end+1} = {vertices(i), vertices(j), comp};
            end
        end
    end
    % Case 2: between an existing vertex and a new vertex
    for i = 1:nV
        for comp = ['R','L','C']
            candidateEdges{end+1} = {vertices(i), nextVertex, comp};
        end
    end
    
    % For each candidate, check count constraints and duplicate edges.
    for k = 1:length(candidateEdges)
        cand = candidateEdges{k};
        compType = cand{3};
        % Count how many edges of this type are in edges
        count = 0;
        for m = 1:length(edges)
            if edges{m}{3} == compType
                count = count + 1;
            end
        end
        if count >= remainingComponents.(compType)
            continue;  % skip if adding would exceed allowed count
        end
        % Check for duplicate: same endpoints and same component
        duplicate = false;
        for m = 1:length(edges)
            if isequal(edges{m}, cand)
                duplicate = true;
                break;
            end
        end
        if duplicate, continue; end
        
        % Construct new network
        newEdges = [edges, {cand}];
        % If the candidate uses a new vertex (i.e. nextVertex appears), add it
        if cand{1} == nextVertex || cand{2} == nextVertex
            newVertices = [vertices, nextVertex];
            newNext = nextVertex + 1;
            new_node = true;
        else
            newVertices = vertices;
            newNext = nextVertex;
            new_node = false;
        end
        
        % Recurse
        solSet = [ solSet; EnumerateNetworks(newVertices, newEdges, newNext, remainingComponents, new_node ) ];
    end
end
