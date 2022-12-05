%% 1-NN classifier with multiple dimension vector
function [sorted,index] = closestEuclidDist(feats,test)

if size(test,2)~=size(feats,2) 
    error('not the same number of features')
end
Nrows=size(feats,1);
euclids = zeros(Nrows,1);
for i=1:Nrows
    euclids(i,1) = norm(feats(i,:)-test);
end

%[sorted1,index1] = sortrows(euclids,1);
[sorted,index] = min(euclids);

end