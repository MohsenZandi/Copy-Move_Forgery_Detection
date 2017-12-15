function result=getMatches_parallel(FeatureMatrix,Locations,threshold,search_th,distance_th)
[num_blocks,FVsize]=size(FeatureMatrix);
%Extend FeatureMatrix with infinity rows
%extension is essential for ballance size of last section with other sections
%we select Infinity for extension beause no FeatureVector can match with infinity
FeatureMatrix=[FeatureMatrix;...
                           inf(search_th,FVsize)];
Locations=[Locations;...
                   inf(search_th,2)];
%divide FeatureMatrix into 4 part for computing on Quad Core CPU
section_size=num_blocks/4+search_th;%size of each section for search
sub_FeatureMatrices=zeros(section_size,FVsize,4);%divide Feature Matrix into 4 sections for parallel processing
sub_Locations=zeros(section_size,2,4);
start_section=1;
for k=1:4
    sub_FeatureMatrices(:,:,k)=FeatureMatrix(start_section  :  start_section+section_size-1,:);
    sub_Locations(:,:,k)=Locations(start_section  :  start_section+section_size-1,:);
    start_section=start_section+section_size-search_th;
end
size_matchlist=(section_size-search_th)*search_th;%maximum size of partial matchlist
MatchList=zeros(size_matchlist,2,4);%4 partial matchlist for store matches
num=zeros(1,4);%Number of found matches
%parallel matching
parfor p=1:4
    [MatchList(:,:,p),num(p)]=getMatches(sub_FeatureMatrices(:,:,p),sub_Locations(:,:,p),search_th,threshold,distance_th,size_matchlist,(p-1)*(section_size-search_th)+1);%num(p) is number of matches in MatchList(:,:,p)
end
result=[[MatchList(1:num(1),:,1);MatchList(1:num(2),:,2);MatchList(1:num(3),:,3);MatchList(1:num(4),:,4)]];%Complete match list
end