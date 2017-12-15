%Run Copy-Move-Detection on a single image.
%
% INPUTS:
%   filename    - name of image file
%   show          - if 1 results will show and else nothing
%
% OUTPUTS:
%   ret            -if true then image is forged else image is authenticated
%
% ---
% Article: Copy-move forgery detection and localization by means of robust clustering with J-Linkage
% ---
% Programmer: Mohsen Zandi
% Student of Master of Engineering - Artifical Intelligence
% Faculty of Electrical and Computer Engineering
% Shahid Beheshti University
% January 2014

% function ret=Main(filename,show)
clc;
close all;
clear;
addpath('jlinkage');
addpath('C:\vlfeat-0.9.20\toolbox');%%%%
vl_setup;%Initialize VLFeat
show=1;
%Get File
[name, path]=uigetfile({'*.jpg;*.png;*.bmp;*.tif','Images (*.jpg,*.png,*.bmp,*.tif)'},'Select An Image');
if isequal(name,0)
    error('User selected Cancel');
end
filename=fullfile(path, name);
%%%% initializations
RGBimage=imread(filename);
tic;%record time for calculate elapsed time
T=0.5; %threshold for G2NN Test
M=500;%Maximum number of affine transforms
e=10;%affine error
N=9;%min number in 1 cluster
W=12;%maximum neighbor distance
min_distance=16;
grayimage=rgb2gray(RGBimage);
%finding keypoints and their Descriptors
[Locations,Descriptors]= vl_sift(single(grayimage));
Locations=Locations([2,1,3,4],:)';
Descriptors=Descriptors';
%Descriptor Normalization
Descriptors=double(Descriptors);
Descriptors=Descriptors./repmat(NormRow(Descriptors,2),1,128);

[num_keypoint ,~]=size(Descriptors);
[n_rows,n_columns,~]=size(RGBimage);

%%%% Matching
Match_Mat=false(num_keypoint);
maximum=min(20,num_keypoint);
[distances,index]=pdist2(Descriptors,Descriptors,'euclidean','smallest',maximum);
for u=1:num_keypoint
    
%     [distances,index]=pdist2(Descriptors(u,:),Descriptors,'smallest',maximum);
%     [distances,index]=sort(distances);
%     bound=find(distances(u,1:maximum-1)./distances(2:maximum)>T,1)-1;%find the first element in which the G2NN condition is not satisfied
%     Match_Mat(index(2:bound),u)=1;
%     Match_Mat(u,index(2:bound))=1;
    for v=2:maximum-1%num_keypoint-1 %start from 2 because distances(1) is zero (each block is most similar to itself)
        if (distances(v,u)<=distances(v+1,u)*T)
            if norm(Locations(u,1:2)-Locations(index(v,u),1:2))<min_distance
                continue;
            end
            Match_Mat(u,index(v,u))=1;
            Match_Mat(index(v,u),u)=1;
        else
            break;
        end
    end
end
num_match=sum(Match_Mat(:));
[t1,t2]=find(Match_Mat);
matchIndices=[t1,t2];
%Show Match Keypoints
if (show==1)
    figure;
    imshow(RGBimage);
    hold on;
    title('Match Keypoints');
    loc1_temp=Locations(matchIndices(:,1),1:2);
    loc2_temp=Locations(matchIndices(:,2),1:2);
    locs_temp=[loc1_temp;loc2_temp];
    plot(locs_temp(:,2),locs_temp(:,1),'go');%Show points
    temp=[loc1_temp,loc2_temp,nan(size(loc2_temp,1),4)]';
    locs_temp=reshape(temp(:),4,[]);
    plot([locs_temp(2,:);locs_temp(4,:)],[locs_temp(1,:);locs_temp(3,:)],'b-');
    hold off;
end
%is there any match?!
if (isempty(matchIndices))
    %there is not any match ,so we dont need to continue
    ret=0;%image is authenticated
    return;
end
%%%% Clustering using J-Linkage
transforms=[];%array of affine transforms
%finding affine transforms
for u=1:M%at each iteration we select 3 near match to compute 1 affine transform
    %select a random match (center match)
    m=randi(num_match,1);
    k1=matchIndices(m,1);
    k2=matchIndices(m,2);
    l1_center= Locations(k1,1:2);
    l2_center= Locations(k2,1:2);
    %find all near matches
    near_1 = findNearestNeighbors(l1_center,Locations(:,1:2),W);
    near_2 = findNearestNeighbors(l2_center,Locations(:,1:2),W);
    [s1,s2]=find(Match_Mat(near_1,near_2));
    MatchList_temp=[near_1(s1)',near_2(s2)'];
    num_match_temp=size(MatchList_temp,1);
    if num_match_temp<2
        continue;
    end
    for z=1:10  %10 times (or maybe less) we try to compute 1 affine transform using center match and 2 random near match
        r=randi(num_match_temp,1:2);%randomly select 2 neighbor match
        temp1=[l1_center ;Locations(MatchList_temp(r(1),1),1:2);Locations(MatchList_temp(r(2),1),1:2)];
        temp2=[l2_center ;Locations(MatchList_temp(r(1),2),1:2);Locations(MatchList_temp(r(2),2),1:2)];
        x1=temp1(:,2);
        y1=temp1(:,1);
        x2=temp2(:,2);
        y2=temp2(:,1);
        %colinear test: 3 selected match must not be colinear
        if ~(iscolinear(temp1(1,:),temp1(2,:),temp1(3,:)) ||  iscolinear(temp2(1,:),temp2(2,:),temp2(3,:)))
            transforms=[transforms;         maketform('affine',[x1,y1],[x2,y2])];%attach this new affine transform
            break;
        end
    end
end
num_tforms=length(transforms);%number of found transforms
%Voting: each match vote to transforms that can participate in its
PS=zeros(num_match,num_tforms);%preference set vectors
for u=1:num_match
    k1=matchIndices(u,1);
    k2=matchIndices(u,2);
    loc1= [Locations(k1,2:-1:1)   ,1]';
    loc2= [Locations(k2,2:-1:1)   ,1]';
    for v=1:num_tforms
        %check: is match(u) inlier of transform (v)
        forward=transforms(v).tdata.T';%forward is a affine transform matrix (3x3)
        %compute error of this match when transforms using transform (v)
        PS(u,v)=norm(forward*loc1-loc2)<e || norm(forward*loc2-loc1)<e; %if error is less than e so this match is inlier and so PS(u,v) will be 1 ,else 0
    end
end
% Hierarchical Clustering
%This clustering is bottom up and cluster matches with similar PS vector
% % % PS_nodes= [[1:num_match]'    ,        PS];%nodes initialization- PS of each node (exactly nodes without father)
% % % z=zeros(num_match-1,3);%output: formated like Linkage function output
% % % % put PS vectors in a hierarchy
% % % for u=1:num_match-1 % at each iteration we add 1 node to tree
% % %     distances=pdist(PS_nodes(:,2:num_tforms+1),'jaccard');%compute jaccard distance between all nodes without father
% % %     distances(isnan(distances))=1;%jaccard distance between 2 zero vector is not a number! (because 0/0)
% % %     min_dis=min(distances(:));%best nodes for joining have minimum distance
% % %     distances=squareform(distances);%make distances array to squareform matrix
% % %     [i,j]=find(distances==min_dis);%find index of best nodes for joining
% % %     %filter founded nodes
% % %     t1=1;
% % %     while i(t1)==j(t1) %index of best nodes must not be same
% % %         t1=t1+1;
% % %     end
% % %     i=i(t1);
% % %     j=j(t1);
% % %     z(u,:)=[PS_nodes(i,1)    PS_nodes(j,1)      min_dis];%add new node to tree
% % %     %we dont need to PS of i and j
% % %     PS_nodes(i,:)=[u+num_match ,   PS_nodes(i,2:num_tforms+1)   &  PS_nodes(j,2:num_tforms+1) ];%PS of new node
% % %     PS_nodes(j,:)=[];
% % % end
% % % %prune tree to make clusters
% % % clusters=cluster(z,'cutoff',1-eps,'criterion','distance');%cut off is less than 1
clusters=clusterPoints(PS==1);%%%
%compute number of joined match in each cluster
num_clusters=max(clusters);%number of found clusters
num_clusters_inliers= zeros(num_clusters,1);%1 column for store number of match that joined in each cluster
for v=1:num_match
    c=clusters(v);
    num_clusters_inliers(c)=num_clusters_inliers(c)+1;
end
%Remove small clusters
rem=false(num_match,1);
for u=1:num_clusters
    if num_clusters_inliers(u)<N
        rem(clusters==u)=1;
    end
end
matchIndices(rem,:)=[];
clusters(rem,:)=[];

%compute PS of each cluster
PS_Cluster=zeros(num_clusters,num_tforms);%PS of each cluster
tform_Cluster=zeros(3,3,num_clusters);%affine transform of each cluster -- matches in each cluster must have one affine transform
for u=1:num_clusters
    if num_clusters_inliers(u)<N
        continue;
    end
    index=find(clusters==u);%find matches of cluster(u)
    temp=ones(1,num_tforms);%temp PS vector
    for v=1:length(index)
        temp=temp & clusters(index(v));
    end
    PS_Cluster(u,:)=temp;
    if sum(temp)>1 %this cluster has more than 1 transform
        %compute 1 transform for cluster
        m=find(clusters==u);
        k1=matchIndices(m,1);
        k2=matchIndices(m,2);
        loc1= Locations(k1,1:2);
        loc2= Locations(k2,1:2);
        x1=loc1(:,2);
        y1=loc1(:,1);
        x2=loc2(:,2);
        y2=loc2(:,1);
        temp=estimateGeometricTransform([x1,y1],[x2 ,y2],'affine');%%
        tform_Cluster(:,:,u)=temp.T;
    else
        tform_Cluster(u)=transforms(temp==1).tdata.T;
    end
end

[num_match, ~]=size(matchIndices);
%Show Clusters
if (show==1)
    figure;
    imshow(RGBimage);
    title('Clusters');
    hold on;
    for u=1:num_clusters
        color=rand(1,3);
        matchlist_temp=matchIndices(clusters==u,:);
        loc1_temp=Locations(matchlist_temp(:,1),1:2);
        loc2_temp=Locations(matchlist_temp(:,2),1:2);
        locs_temp=[loc1_temp;loc2_temp];
        plot(locs_temp(:,2),locs_temp(:,1),'o','color',color);%Show points
    end
    hold off;
end
if ~isempty(matchIndices)
    ret=1;%forged image
    if show==0
        return;
    end
else
    ret=0;%real image
    return;
end
%if image is forged and show is 1 then we localize the copied patch
%%%% Path Localization
grayimage=rgb2gray(RGBimage);
UltimateResult=RGBimage;
for u=1:num_clusters
    if num_clusters_inliers(u)<N
        continue;
    end
    forward=maketform('affine',tform_Cluster(:,:,u));%convert affine matrix to affine transform structure
    temp=invert(affine2d(forward.tdata.T));%invert forward affine to make backward
    backward=maketform('affine',temp.T);%convert affine matrix to affine transform structure
    img_f=imtransform(grayimage,forward,'xdata',[1, n_columns],'ydata',[1, n_rows]);
    img_b=imtransform(grayimage,backward,'xdata',[1, n_columns],'ydata',[1, n_rows]);
    color=randi(255,1,3);%random color
    out_f=PatchLocalization(grayimage,img_f);%localize copied patch
    out_b=PatchLocalization(grayimage,img_b);%localize copied patch
    %mark patches in output result
    for x=1:n_columns
        for y=1:n_rows
            if  out_f(y,x)==1  || out_b(y,x)==1
                UltimateResult(y,x,:)=color;
            end
        end
    end
end
if (show==1)
    figure;
    imshow(UltimateResult);
    title('Ultimate Result with Patch Localization');
    toc%Print Elapsed Time
end
