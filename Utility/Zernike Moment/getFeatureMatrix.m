function [FeatureMatrix,Locations]=getFeatureMatrix(grayimage,B,FVsize)
%init feature extraction
Vstars=complex(zeros(B,B,12));%array of V stars
%Compute Vstars
Vstars(:,:,1)= getVstar(B, 0,0);
Vstars(:,:,2)= getVstar(B, 1,1);
Vstars(:,:,3)= getVstar(B, 2,0);
Vstars(:,:,4)= getVstar(B, 2,2);
Vstars(:,:,5)= getVstar(B, 3,1);
Vstars(:,:,6)= getVstar(B, 3,3);
Vstars(:,:,7)= getVstar(B, 4,0);
Vstars(:,:,8)= getVstar(B, 4,2);
Vstars(:,:,9)= getVstar(B, 4,4);
Vstars(:,:,10)= getVstar(B,5,1);
Vstars(:,:,11)= getVstar(B,5,3);
Vstars(:,:,12)= getVstar(B,5,5);
% %Compute count of pixels in unit circle
% count = nnz(Vstars(:,:,1))+1;
%%%%
[M ,N]=size(grayimage);
num_blocks=(M-B+1)*(N-B+1);%number of blocks
FeatureMatrix=zeros(num_blocks,FVsize);
Locations=zeros(num_blocks,2);
rownum=0;%row number in FeatureMatrix
for x=1:N-B+1
    for y=1:M-B+1
        block=grayimage(y:y+B-1,x:x+B-1);
        rownum=rownum+1;
        %Store Features
        FeatureMatrix(rownum,:)=getFeatureVector(block,FVsize,Vstars);
        Locations(rownum,:)=[x,y];
    end
end