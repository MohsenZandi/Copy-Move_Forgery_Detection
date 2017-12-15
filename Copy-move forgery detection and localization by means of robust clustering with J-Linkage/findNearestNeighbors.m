function output = findNearestNeighbors(target,data,number)
dist=pdist2(target,data);
[dist2,index]=sort(dist);
index2=index(dist2~=0);
output=index2(1:number);%Because the 1st one is
end

