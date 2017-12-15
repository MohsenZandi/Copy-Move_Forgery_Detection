function out =hasNeighbor(MatchLocations,distance_th)
num=size(MatchLocations,1);
out=false(num,1);
for u=1:num
    if out(u)==0
        for v=1:num
            if v~=u && norm(MatchLocations(u,1:2)-MatchLocations(v,1:2))<=distance_th && norm(MatchLocations(u,3:4)-MatchLocations(v,3:4))<=distance_th
                out(u)=1;
                out(v)=1;
                break;
            end
        end
    end
end
index=find(out==0);
num_new=length(index);
for u=1:num_new
    x=index(u);
    if out(x)==0
        for v=1:num
            if v~=x && norm(MatchLocations(x,1:2)-MatchLocations(v,3:4))<=distance_th && norm(MatchLocations(x,3:4)-MatchLocations(v,1:2))<=distance_th
                out(x)=1;
                out(v)=1;
                break;
            end
        end
    end
end