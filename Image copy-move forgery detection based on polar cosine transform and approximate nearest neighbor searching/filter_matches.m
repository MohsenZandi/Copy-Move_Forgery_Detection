function new_MatchList=filter_matches(MatchList,Locations,w,min_neigh,max_std)
num_matches=size(MatchList,1);
location1=Locations(MatchList(:,1),:);
location2=Locations(MatchList(:,2),:);
new=false(num_matches,1);
for i=1:num_matches
    loc_C1=location1(i,:);
    loc_C2=location2(i,:);
    d11=pdist2(loc_C1,location1,'cityblock');
    d22=pdist2(loc_C2,location2,'cityblock');
    neighbors1=(d11+d22)~=0 & d11<=w & d22<=w;
    d12=pdist2(loc_C1,location2,'cityblock');
    d21=pdist2(loc_C2,location1,'cityblock');
    neighbors2=(d12+d21)~=0 & d12<=w & d21<=w;
    neighbors=neighbors1 | neighbors2;         
    num_neigh=sum(neighbors);
    if (num_neigh<min_neigh)
        continue;
    end
    loc1=[location1(neighbors1,:);...
          location2(neighbors2,:)];
    loc2=[location2(neighbors1,:);...
          location1(neighbors2,:)];

    s1=zeros(num_neigh,2);
    s2=zeros(num_neigh,2);
    s1(:,1)=loc1(:,1)-loc_C1(1);
    s1(:,2)=loc1(:,2)-loc_C1(2);
    s2(:,1)=loc2(:,1)-loc_C2(1);
    s2(:,2)=loc2(:,2)-loc_C2(2);
    alpha1=atan2(s1(:,2),s1(:,1))*180/pi;
    alpha2=atan2(s2(:,2),s2(:,1))*180/pi;
    alpha_d=difference_angular(alpha1,alpha2);
    x=std(alpha_d,1);
    if(x<=max_std)
        new(i)=1;
        new(neighbors)=1;
    end
end
new_MatchList=MatchList(new,:);
end