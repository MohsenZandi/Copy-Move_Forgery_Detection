% Programmer: Mohsen Zandi
% Student of Master of Engineering - Artifical Intelligence
% Faculty of Electrical and Computer Engineering
% Shahid Beheshti University
% May 2014

% initilization
clc;%clear command window
clear all;%clear all variables
close all%close all result windows;
method='Cao DCT';%name of method for saving result
color=[0,0,255];
filename=input('Enter File Name: ','s');
resultName='';%strcat('results\',method,filename);
RGBimage=imread(filename);
tic;%record time for calculate elapsed time
grayimage=double(rgb2gray(RGBimage)); % convert RGB to gray
[M ,N]=size(grayimage);
B=8;%Block Dimension =B x B
search_th=5;%threshold for search length in matching
distance_th=120;
num_blocks=(M-B+1)*(N-B+1);%number of blocks
FVsize=4;%Feature Vector Length
Similarity_threshold=0.0015;%factor of similarity
% get feature matrix (extract feature of all overlapped blocks)
[FeatureMatrix,Locations]=getFeatureMatrix_parallel(grayimage,B,FVsize);
% Sorting
[FeatureMatrix,index]=sortrows(FeatureMatrix);
Locations=Locations(index,:);
% Matching (finding similar blocks)
MatchList=getMatches_parallel(FeatureMatrix,Locations,Similarity_threshold,search_th,distance_th);
% filtering

% show result
showMatches(RGBimage,MatchList,Locations,B,color,1,1,resultName);
toc%print elapsed time