%Run Copy-Move-Detection on a single image.
% ---
% Article: Detection of Copy-Rotate-Move Forgery Using Zernike Moments
% ---
% Programmer: Mohsen Zandi
% Student of Master of Engineering - Artifical Intelligence
% Faculty of Electrical and Computer Engineering
% Shahid Beheshti University
% April 2014

clc;%clear command window
clear all;%clear all variables
close all%close all result windows;
addpath('Zernike Moment');
method='';%name of method for saving result
% initilization
filename=input('Enter File Name: ','s');
resultName=strcat('results\',method,filename);
color=[0,0,255];
RGBimage=imread(filename);
tic;%record time for calculate elapsed time
grayimage=double(rgb2gray(RGBimage)); % convert RGB to gray
[M ,N]=size(grayimage);
B=24;%Block Dimension =B x B
search_th=50;%threshold for search length in matching
distance_th=50;
num_blocks=(M-B+1)*(N-B+1);%number of blocks
FVsize=12;%Feature Vector Length
Similarity_threshold=0.1;%factor of similarity
% get feature matrix (extract feature of all overlapped blocks)
[FeatureMatrix,Locations]=getFeatureMatrix_parallel(grayimage,B,FVsize);
% Sorting
[FeatureMatrix,index]=sortrows(FeatureMatrix);
Locations=Locations(index,:);
% Matching (finding similar blocks)
MatchList=getMatches_parallel(FeatureMatrix,Locations,Similarity_threshold,search_th,distance_th);
num_matches=size(MatchList,1);
% filtering

% show result
showMatches(RGBimage,MatchList,Locations,B,color,1,1,resultName);
toc%print elapsed time