function MatchList=getMatches_LSH(FeatureMatrix,Phase,Locations,r,p,q,degree,distance_th)
[~,FVsize]=size(FeatureMatrix);
[a,b]=MakeBuckets(FVsize,p,q,r);
%Create Combined Buckets (if degree>1 ==> hash will change)
comb_buck=combnk(1:q,degree);
q_new=size(comb_buck,1);
p_new=degree*p;
a_new=zeros(FVsize,p_new,q_new);
b_new=zeros(1,p_new,q_new);
for u=1:q_new
   a_new(:,:,u) =reshape(a(:,:,comb_buck(u,:)),FVsize,p_new);
   b_new(:,:,u)=reshape(b(:,:,comb_buck(u,:)),1,p_new);
end
%Hash
hashed=Hash(FeatureMatrix,a_new,b_new,r);
pairs=[];
for u=1:q
    pairs=[pairs;getEquals(hashed(:,:,u),Locations,distance_th)];
end
[siz,~]=size(pairs);
if siz==0
    return
end
% %Normalization
index=pairs(:,1)>pairs(:,2);
pairs(index,:)=[pairs(index,2),pairs(index,1)];
% %Remove Repetitive Matches
pairs=getRepetitives(pairs,1);
MatchList=[pairs,difference_angular(Phase(pairs(:,1)),Phase(pairs(:,2)))];
end