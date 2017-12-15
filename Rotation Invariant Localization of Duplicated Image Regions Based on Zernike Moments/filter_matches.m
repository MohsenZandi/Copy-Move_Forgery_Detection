function out_MatchList=filter_matches(MatchList,Locations)
T1=2;
T2=0.03;
T3=2;
T4=2;
num_iter=100;
w=50;%neighborhood distance
max_matches=0;
best_matches=[];
for alpha=0:180
    i1=find(abs(MatchList(:,3)-alpha)<T1);
    alpha_MatchList=MatchList(i1,1:2);
    alpha_MatchLocations=[Locations(alpha_MatchList(:,1),:),Locations(alpha_MatchList(:,2),:)];
    i2=find(NumberNeighbors(alpha_MatchLocations,w)>0);
    new_MatchList=alpha_MatchList(i2,1:2);
    new_MatchLocations=[Locations(new_MatchList(:,1),:),Locations(new_MatchList(:,2),:)];
    siz_MatchList=size(new_MatchLocations,1);
    if siz_MatchList<3
        continue;%Not enough point
    end
    for iter=1:num_iter
        r1=randi(siz_MatchList,1);
        r1_loc=new_MatchLocations(r1,:);
        [r1_neigh,inverse]=getNeighbors(r1_loc,new_MatchLocations,w);
        index=find(r1_neigh==1);
        siz_neighb=length(index);
        r2=index(randi(siz_neighb,1));
        if inverse(r2)
            r2_loc=new_MatchLocations(r2,[3,4,1,2]);
        else
            r2_loc=new_MatchLocations(r2,:);
        end
        [r2_neigh,inverse]=getNeighbors(r2_loc,new_MatchLocations,w);
        neighb=r1_neigh | r2_neigh;
        index=find(neighb==1);
        siz_neighb=length(index);
        r3=index(randi(siz_neighb,1));
        if inverse(r3)
            r3_loc=new_MatchLocations(r3,[3,4,1,2]);
        else
            r3_loc=new_MatchLocations(r3,:);
        end
        %Estimate Affine Transform
        loc1=[r1_loc(1:2);r2_loc(1:2);r3_loc(1:2)];
        loc2=[r1_loc(3:4);r2_loc(3:4);r3_loc(3:4)];
        if isColinear(loc1(1,:),loc1(2,:),loc1(3,:)) || isColinear(loc2(1,:),loc2(2,:),loc2(3,:))
            continue;
        end
        transform=maketform('affine',loc1,loc2);
        forward=transform.tdata.T';%forward is a affine transform matrix (3x3)
        %Check Affine Transform
        M=forward(1:2,1:2);
        [u,sig,v]=svd(M);
        s=u*sig*u';
        r=u*v';
        alphaR=acos(min(r(1,1),1))*180/pi;
        sinv=inv(s);
        if norm(eye(2)-sinv(1,1).*s,'fro')>=T2 || difference_angular(alphaR,alpha)>=T3
            continue;
        end
        %Check Other Matches
        locations1=[new_MatchLocations(:,1:2),ones(siz_MatchList,1)]';
        locations2=[new_MatchLocations(:,3:4),ones(siz_MatchList,1)]';
        potential_Matches=find(NormRow(forward*locations1-locations2,1)<T4 | NormRow(forward*locations2-locations1,1)<T4);
        if length(potential_Matches)>max_matches
            max_matches=length(potential_Matches);
            best_matches=i1(i2(potential_Matches));
        end
    end
end
out_MatchList=MatchList(best_matches,1:2);