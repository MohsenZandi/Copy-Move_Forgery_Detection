%Quad Core
function [FeatureMatrix,Locations]=getFeatureMatrix_parallel(grayimage,B,FVsize)
[M,N]=size(grayimage);
%Crop image for parallel computing
if (mod(M+B,2))==0
    M=M-1;
    grayimage=grayimage(1:M,:);
end
if (mod(N+B,2))==0
    N=N-1;
    grayimage=grayimage(:,1:N);
end
%
c1=(M+B-1)/2;
c2=(N+B-1)/2;
sub_images=zeros(c1 ,c2, 4);%sub images for parallel processing (sub images have overlap)
sub_images(:,:,1)=grayimage(1:c1 ,1:c2);
sub_images(:,:,2)=grayimage(1:c1 ,c2-B+2:N);
sub_images(:,:,3)=grayimage(c1-B+2:M ,1:c2);
sub_images(:,:,4)=grayimage(c1-B+2:M ,c2-B+2:N);

sections=[0                  0;...  %location of each sub image in main image(left upper corner)
                 0                  c2-B+1; ...
                 c1-B+1         0;...
                 c1-B+1         c2-B+1];

Mats=zeros((c1-B+1)*(c2-B+1),FVsize,4);%matrices for store result of parallel Feature Extraction
locs=zeros((c1-B+1)*(c2-B+1),2,4);
%start 4 thread for feature extraction of each sub image (parfor==parallel for)
parfor h=1:4
    [Mats(:,:,h),locs(:,:,h)]=getFeatureMatrix(sub_images(:,:,h),B,FVsize);
end
FeatureMatrix=[Mats(:,:,1)  ;Mats(:,:,2)  ;Mats(:,:,3) ; Mats(:,:,4)];%create complete feature matrix

Locations=[locs(:,1,1)+sections(1,2),locs(:,2,1)+sections(1,1);...
                   locs(:,1,2)+sections(2,2),locs(:,2,2)+sections(2,1);...
                   locs(:,1,3)+sections(3,2),locs(:,2,3)+sections(3,1);...
                   locs(:,1,4)+sections(4,2),locs(:,2,4)+sections(4,1)];
end