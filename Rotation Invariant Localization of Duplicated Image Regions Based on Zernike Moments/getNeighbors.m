function [neighbors,inverse_neighbors] = getNeighbors( MatchLocation,AllMatchLocations,distance_th )
d1=pdist2(MatchLocation(:,1:2),AllMatchLocations(:,1:2));
d2=pdist2(MatchLocation(:,3:4),AllMatchLocations(:,3:4));
d3=pdist2(MatchLocation(:,3:4),AllMatchLocations(:,1:2));
d4=pdist2(MatchLocation(:,1:2),AllMatchLocations(:,3:4));
neighbors1=d1<=distance_th & d2<=distance_th  &  (d1+d2)>0;
neighbors2=d3<=distance_th & d4<=distance_th  &  (d3+d4)>0;
neighbors=neighbors1|neighbors2;
inverse_neighbors=neighbors2;
end

