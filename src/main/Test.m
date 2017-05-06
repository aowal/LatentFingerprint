addpath('../similarity/')

% getMostSimilarMatrix([],[])

X = [1,111]
Y = [1,2]

sum(pdist2(X,Y,'jaccard'))
