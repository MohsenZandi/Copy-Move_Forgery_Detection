
% Programmer: Mohsen Zandi
% Student of Master of Engineering - Artifical Intelligence
% Faculty of Electrical and Computer Engineering
% Shahid Beheshti University
% April 2014

clc;%clear command window
clear all;%clear all variables
close all%close all result windows;
addpath('Zernike Moment');
addpath('LSH Matching');
method='Z13-C-';%name of method for saving result
FVsize=12;%Feature Vector Length
B=24;%Block Dimension =B x B
search_th=50;%threshold for search length in matching
distance_th=50;
%LSH Setting
r=1500;
p=30;
q=9;
degree=1;
%result color
color=[255,0,0];
% initilization
filename=input('Enter File Name: ','s');
RGBimage=imread(filename);
tic;%record time for calculate elapsed time
grayimage=double(rgb2gray(RGBimage)); % convert RGB to gray
[M ,N]=size(grayimage);
num_blocks=(M-B+1)*(N-B+1);%number of blocks
% get feature matrix (extract feature of all overlapped blocks)
[FeatureMatrix,Locations]=getFeatureMatrix_parallel(grayimage,B,FVsize+1);
Phase=FeatureMatrix(:,FVsize+1);
FeatureMatrix=FeatureMatrix(:,1:FVsize);
% Matching (finding similar blocks)
MatchList=getMatches_LSH(FeatureMatrix,Phase,Locations,r,p,q,degree,distance_th);
fprintf('Size of MatchList: %d\n',size(MatchList,1));
% filtering
showMatches(RGBimage,MatchList,Locations,B,color,0,1,'Before Filtering');
new_MatchList=filter_matches(MatchList,Locations);
% show result
showMatches(RGBimage,new_MatchList,Locations,B,color,0,0,'After Filtering');
toc%print elapsed time