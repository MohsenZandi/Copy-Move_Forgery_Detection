function number = NumberNeighbors( AllMatchLocations ,distance_th)
num_matches=size(AllMatchLocations ,1);
number=zeros(num_matches,1);
for u=1:num_matches
    number(u)=sum(getNeighbors(AllMatchLocations(u,:),AllMatchLocations,distance_th));%number of 1s
end

