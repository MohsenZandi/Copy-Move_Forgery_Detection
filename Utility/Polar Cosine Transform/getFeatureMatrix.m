function [FeatureMatrix,StandardDeviations]=getFeatureMatrix(grayimage,B,FVsize,Keypoint_Locations)%Non-Overlap-By Distance
%init
param=[0    0;...%Table of N, L parameters
       0	1;...
       0	2;...
       1	0;...
       1	1;...
       1    2;...
       2    0;...
       2    1];
hStars=zeros(B,B,FVsize);
r=floor(B/2);
for k=1:FVsize-1
        hStars(:,:,k)=getHstar(param(k,1),param(k,2),B);       
end
mask=getCircleMask(B);
grayimage=double(grayimage);
num_blocks=size(Keypoint_Locations,1);%number of keypoints
FeatureMatrix=zeros(num_blocks,FVsize);
StandardDeviations=zeros(num_blocks,1);
% lap=double(imfilter(grayimage,fspecial('laplacian'))).^2;
c=(mod(B,2)==0)*(-1);
for u=1:num_blocks
            x=Keypoint_Locations(u,1);
            y=Keypoint_Locations(u,2);
            block=grayimage(y-r:y+r+c,x-r:x+r+c);
            %Store Features
            FeatureMatrix(u,:)=getFeatureVector(block,FVsize,hStars,param);
            StandardDeviations(u)=std(block(mask(:)),1);%sqrt(sum(sum(lap(y-r:y+r-1,x-r:x+r-1))));%
end
