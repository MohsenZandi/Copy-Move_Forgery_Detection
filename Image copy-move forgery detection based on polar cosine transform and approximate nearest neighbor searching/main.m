% Programmer: Mohsen Zandi
% Student of Master of Engineering - Artifical Intelligence
% Faculty of Electrical and Computer Engineering
% Shahid Beheshti University
% April 2014

clc;%clear command window
clear all;%clear all variables
close all%close all result windows;
addpath('Polar Cosine Transform');
addpath('LSH Matching');
method='PCT-Constant-';%name of method for saving result
FVsize=9;%Feature Vector Length
neighbor_radios=12;
min_neighbors=6;
max_std=10;
B=24;%Block Dimension =B x B
search_th=50;%threshold for search length in matching
distance_th=120;
color=[255,0,0];
%LSH Setting
degree=4;
r=15;
p=1;
q=8;
% initilization
filename=input('Enter File Name: ','s');
RGBimage=imread(filename);
tic;%record time for calculate elapsed time
grayimage=double(rgb2gray(RGBimage)); % convert RGB to gray
[M ,N]=size(grayimage);
num_blocks=(M-B+1)*(N-B+1);%number of blocks
% get feature matrix (extract feature of all overlapped blocks)
Selection_Mask=true(M,N);
Margin=B/2;
Selection_Mask(1:Margin,:)=0;
Selection_Mask(:,1:Margin)=0;
Selection_Mask(M-Margin:M,:)=0;
Selection_Mask(:,N-Margin:N)=0;
[y,x]=find(Selection_Mask);
Locations=[x,y];
FeatureMatrix=getFeatureMatrix_parallel(grayimage,B,FVsize,Locations);
FeatureMatrix=FeatureMatrix(:,1:FVsize-1);
% Matching (finding similar blocks)
MatchList=getMatches_LSH(FeatureMatrix,Locations,r,p,q,degree,distance_th);
% filtering
new_MatchList=filter_matches(MatchList,Locations,neighbor_radios,min_neighbors,max_std);
% show result
showMatches(RGBimage,new_MatchList,Locations,B,color,1,1,'');
toc%print elapsed time