%Run Copy-Move-Detection on a single image.
% ---
% Article: A robust detection algorithm for copy-move forgery in digital images
% ---
% Programmer: Mohsen Zandi
% Student of Master of Engineering - Artifical Intelligence
% Faculty of Electrical and Computer Engineering
% Shahid Beheshti University
% April 2014
clc;%clear command window
clear all;%clear all variables

filename=input('Enter File Name: ','s');
RGBimage=imread(filename);
tic;%record time for calculate elapsed time
grayimage=rgb2gray(RGBimage); % convert RGB to gray
[M ,N]=size(grayimage);
B=8;%Block Dimension =B x B
num_blocks=(M-B+1)*(N-B+1);%number of blocks
FVsize=4;%size of feature vector
FeatureMatrix=zeros(num_blocks,FVsize+3);%+2 for row - column of left upper corner + std
search_th=50;
MinDistance=50;
Similarity_th=0.00;

%%Create Circle Mask
circle=ones(B,B);
for i=1:B
    for j=1:B
        if norm([i-(B+1)/2,j-(B+1)/2])<=B/2
            circle(i,j)=1;
        end
    end
end
%Quarters of square
quarter2_mask=[zeros(B/2,B/2),ones(B/2,B/2); ...
    zeros(B/2,B/2), zeros(B/2,B/2)];
quarter1_mask=[ones(B/2,B/2) , zeros(B/2,B/2); ...
    zeros(B/2,B/2), zeros(B/2,B/2)];
quarter3_mask=[zeros(B/2,B/2) , zeros(B/2,B/2); ...
    ones(B/2,B/2), zeros(B/2,B/2)];
quarter4_mask=[zeros(B/2,B/2) , zeros(B/2,B/2); ...
    zeros(B/2,B/2), ones(B/2,B/2)];
%Quarters of circle
quarter1_mask=quarter1_mask & circle;
quarter2_mask=quarter2_mask & circle;
quarter3_mask=quarter3_mask & circle;
quarter4_mask=quarter4_mask & circle;
area_quarter=sum(sum(quarter1_mask));
%Blocking & Feature Extraction
rownum=1;
for i=1:M-B+1
    for j=1:N-B+1
        block=grayimage(i:i+B-1,j:j+B-1);
        Block_DCT=dct2(block);%DCT of Block
        v=[sum(sum(quarter1_mask*Block_DCT)),  sum(sum(quarter2_mask*Block_DCT)),   sum(sum(quarter3_mask*Block_DCT))   , sum(sum(quarter4_mask*Block_DCT))]/(B.^2/4);%Feature Vector
        %put block in a row
        FeatureMatrix(rownum,:)=[v ,i  ,j   ,std(double(block(:)),1)];
        rownum=rownum+1;
    end
end
max_std=max(FeatureMatrix(:,FVsize+3));
min_std=min(FeatureMatrix(:,FVsize+3));
Main2;