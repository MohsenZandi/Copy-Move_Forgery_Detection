%Run Copy-Move-Detection on a single image.
% ---
% Article: Detection of Copy-Move Forgery in Digital Images
% ---
% Programmer: Mohsen Zandi
% Student of Master of Engineering - Artifical Intelligence
% Faculty of Electrical and Computer Engineering
% Shahid Beheshti University
% December 2013
clc;%clear command window
clear all;%clear all variables

filename=input('Enter File Name: ','s');
RGBimage=imread(filename);
Th_ShiftCount=input('Enter threshold for shift count: '); % Min count for shift
StartTime=tic;%record time for calculate elapsed time
grayimage=RGBimage(:,:,1)*0.299+RGBimage(:,:,2)*0.587+RGBimage(:,:,3)*0.114; % convert RGB to gray
[M N]=size(grayimage);
B=16;%Block Dimension =B x B
MinShiftSize=B;
num_blocks=(M-B+1)*(N-B+1);%number of blocks
FeatureMatrix=int16(zeros(num_blocks,B*B+2));%+2 for row - column of left upper corner

Q8 = ...    % standard quantization table for JPEG (8x8 matrix)
    [ 16  11  10  16  24  40  51  61; ...
    12  12  14  19  26  58  60  55; ...
    14  13  16  24  40  57  69  56; ...
    14  17  22  29  51  87  80  62; ...
    18  22  37  56  68 109 103  77; ...
    24  35  55  64  81 104 113  92; ...
    49  64  78  87 103 121 120 101; ...
    72  92  95  98 112 100 103  99 ];
Q8Prime=2.5*Q8;
Q8Prime(1,1)=2*Q8(1,1);
Q16=[Q8Prime                      2.5*Q8(1,8)*ones(8,8);... %quantization table for quantize 16x16 DCT blocks
    2.5*Q8(8,1)*ones(8,8)         2.5*Q8(8,8)*ones(8,8)];

ShiftVectors=[0 0 0];
blockShiftIndex=[];
lastSVindx=1;

%Blocking & Feature Extraction
rownum=1;
for i=1:M-B+1
    for j=1:N-B+1
        Block_DCT_Quantized=round(dct2(grayimage(i:i+B-1,j:j+B-1))./Q16);%DCT of Block And Quantize it
        %put block in a row
        row=zeros(1,B*B);
        for k=1:B
            row((k-1)*B+1:k*B)=Block_DCT_Quantized(k,:);
        end
        FeatureMatrix(rownum,:)=[row i j];
        rownum=rownum+1;
    end
end
%Sorting
FeatureMatrix=sortrows(FeatureMatrix);
%Matching Similar Blocks & Filtering by Blocks Distance
for i=1:num_blocks-1
    if(FeatureMatrix(i,1:B*B)==FeatureMatrix(i+1,1:B*B))
        shift=FeatureMatrix(i,B*B+1:B*B+2)-FeatureMatrix(i+1,B*B+1:B*B+2);
        %filtering by location difference
        if(norm(double(shift))<MinShiftSize)
            continue;
        end
         %normalize shift vector
        if((shift(1,1)<0 && shift(1,2)<=0)||(shift(1,1)>=0 && shift(1,2)<0))
            shift=-shift;
        end
        %find shift vector
        indx=find(ShiftVectors(:,1)==shift(1,1) & ShiftVectors(:,2)==shift(1,2));
        if(isempty(indx)==0)%found
            ShiftVectors(indx,3)=ShiftVectors(indx,3)+1;%increase shift counter
        else  %not found  = new shift vector
            lastSVindx=lastSVindx+1;
            ShiftVectors=[ShiftVectors; 
                             shift 1];
            indx=lastSVindx;
        end
        blockShiftIndex=[blockShiftIndex;
                            indx   i;
                            indx   i+1];
    end
end
elapsedTime=toc(StartTime);
fprintf('Elapsed Time: %.1f Second \n', elapsedTime);
%Filtering & Representing Blocks Of Each Shift Vector
for i=1:lastSVindx%for number of shift vectors
    if (ShiftVectors(i,3)>Th_ShiftCount)%filtering by shift counting
        randomColor=rand(1,3);%create random RGB color
        imshow(RGBimage);
        for j=1:size(blockShiftIndex)%for number of similar blocks
            if(blockShiftIndex(j,1)==i)
                %Colorize blocks
                block_index=blockShiftIndex(j,2);
                block_y=FeatureMatrix(block_index,B*B+1);
                block_x=FeatureMatrix(block_index,B*B+2);
                for k = 0 : B-1
                    line([block_x   block_x+B],[block_y+k   block_y+k],'color',randomColor);
                end
            end
        end
        title(sprintf('Shift Index=%d   Shift Vector=( %d , %d )',i,ShiftVectors(i,1),ShiftVectors(i,2)));
        ginput(1);
    else
        blockShiftIndex(find(blockShiftIndex(:,1)==i),:)=[];%remove filtered blocks
    end
end
%show ultimate result
imshow(RGBimage);
title('Ultimate Result');
for i=1:size(blockShiftIndex)%for number of similar blocks
                %Colorize blocks
                block_index=blockShiftIndex(i,2);
                block_y=FeatureMatrix(block_index,B*B+1);
                block_x=FeatureMatrix(block_index,B*B+2);
                for j = 0 : B-1
                    line([block_x   block_x+B],[block_y+j   block_y+j],'color','g');
                end
end

