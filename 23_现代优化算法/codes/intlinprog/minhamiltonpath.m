function [order, totdist] = minhamiltonpath(D)
% http://www.mathworks.com/help/optim/ug/travelling-salesman-problem.html
% Zhou Lvwen: zhou.lv.wen@gmail.com
% July 21, 2015

%Step 1: Setup linear progrm
N = size(D, 1);
idxs = nchoosek(1:N, 2);
dist = D(sub2ind([N, N], idxs(:, 1), idxs(:, 2)));
lendist = length(dist);

%There need to be two "trips" atached to each "stop"
Aeq = spalloc(N, length(idxs), N*(N-1));
for i = 1:N
    whichIdxs = idxs(:,1) == i | idxs(:,2) == i;
    Aeq(i,whichIdxs) = 1;
end
beq = 2*ones(N, 1);

intcon = 1:lendist;
lb = zeros(lendist, 1);
ub = ones(lendist, 1);

opts = optimoptions('intlinprog','Display','off');

%Step 2: Solve linear program, adding inequality constraints until
%subtours are eliminated from found solution
x = intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);

tours = detectSubtours(x, idxs);
ntours = length(tours);

A = spalloc(0, lendist, 0);
b = [];
while ntours > 1
    fprintf(1, '%i subtours\n', ntours);
    for i = 1:ntours
        rowIdx = size(A, 1)+1;
        touri = tours{i}; % Extract the current subtour
        variations = nchoosek(1:length(touri), 2);
        for j = 1:length(variations)
            whichVar = (sum(idxs==touri(variations(j,1)),2)) & ...
                       (sum(idxs==touri(variations(j,2)),2));
            A(rowIdx, whichVar) = 1;
        end
        b(rowIdx) = length(touri)-1;
    end
    x = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub,opts);
    tours = detectSubtours(x, idxs);
    ntours = length(tours);
end
totdist = dist'*x;
order = tours{:};

% -------------------------------------------------------------------------

function subTours = detectSubtours(x,idxs)
x = round(x); 
r = find(x);
substuff = idxs(r,:); 
unvisited = ones(length(r),1); 
curr = 1; 
startour = find(unvisited,1); 
while ~isempty(startour)
    home = substuff(startour,1);
    nextpt = substuff(startour,2);
    visited = nextpt;
    unvisited(startour) = 0;
    
    while nextpt ~= home
        [srow,scol] = find(substuff == nextpt);
        trow = srow(srow ~= startour);
        scol = 3-scol(trow == srow); 
        startour = trow;
        nextpt = substuff(startour,scol);
        
        visited = [visited,nextpt]; 
        unvisited(startour) = 0; 
    end
    subTours{curr} = visited; 
    curr = curr + 1;
    startour = find(unvisited,1);
end
