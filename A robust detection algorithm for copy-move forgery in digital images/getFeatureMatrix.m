function [FeatureMatrix,Locations]=getFeatureMatrix(grayimage,B,FVsize)
%init
circle=getCircleMask(B);
%Quarters of square
quarter1_mask=[zeros(B/2,B/2),ones(B/2,B/2); ...
    zeros(B/2,B/2), zeros(B/2,B/2)];
quarter2_mask=[ones(B/2,B/2) , zeros(B/2,B/2); ...
    zeros(B/2,B/2), zeros(B/2,B/2)];
quarter3_mask=[zeros(B/2,B/2) , zeros(B/2,B/2); ...
    ones(B/2,B/2), zeros(B/2,B/2)];
quarter4_mask=[zeros(B/2,B/2) , zeros(B/2,B/2); ...
    zeros(B/2,B/2), ones(B/2,B/2)];
%Quarters of circle
q1=quarter1_mask & circle;
q2=quarter2_mask & circle;
q3=quarter3_mask & circle;
q4=quarter4_mask & circle;
area_quarter=sum(sum(q1));
q1=q1/area_quarter;
q2=q2/area_quarter;
q3=q3/area_quarter;
q4=q4/area_quarter;
%
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
        FeatureMatrix(rownum,:)=getFeatureVector(block,q1,q2,q3,q4);
        Locations(rownum,:)=[x,y];
    end
end
end