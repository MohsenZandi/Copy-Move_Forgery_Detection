%Patch Localization
%
% INPUTS:
%   org      - original image matrix
%   warp   -warped image matrix (org image after transform)
%
% OUTPUTS:
%   output   -image matrix with localized patch
%
% ---
% Article: Copy-move forgery detection and localization by means of robust clustering with J-Linkage
% ---
% Programmer: Mohsen Zandi
% Student of Master of Engineering - Artifical Intelligence
% Faculty of Electrical and Computer Engineering
% Shahid Beheshti University
% January 2014
function output=PatchLocalization(org,warp)
[M,N]=size(org);
w_size=3;%window size==7
output=zeros(M,N);
org=double(org);
warp=double(warp);
h=fspecial('average',w_size*2+1);
org_mean_map=imfilter(org,h);
warp_mean_map=imfilter(warp,h);
%correlation between Org image and Warp image
for r=1+w_size:M-w_size
    for c=1+w_size:N-w_size
        regionOrg=org(r-w_size:r+w_size,c-w_size:c+w_size);
        regionWarp=warp(r-w_size:r+w_size,c-w_size:c+w_size);
        meanOrg=org_mean_map(r,c);%mean(regionOrg(:));
        meanWarp=warp_mean_map(r,c);%mean(regionWarp(:));
        %den = sqrt(sum(sum((regionLeft - meanLeft).^2))*sum(sum((regionRight - meanRight).^2)))+eps;
        t1=regionOrg - meanOrg;
        t2=regionWarp - meanWarp;
        t3=t1.*t2;
        t4=t3.^2;
        %sig1=sqrt(sum(sum(t1.^2)));
        %sig2=sqrt(sum(sum(t2.^2)));
        %den = sig1*sig2;%*((2*w_size+1)^2);
        %output(r,c) = sum(sum(t3))/den;%correlation between 2 window
        output(r,c)=sum(t3(:))/sqrt(sum(t4(:)));
    end
end
%normalize output
temp=output(1+w_size:M-w_size,1+w_size:N-w_size);%Because the boundary must not be considered
temp=temp-min(temp(:));
temp=uint8(round(temp*255/max(temp(:))));
output(1+w_size:M-w_size,1+w_size:N-w_size)=temp;
%gaussian filter
h = fspecial('gaussian', 7, 0.5);
output = imfilter(uint8(output), h);
%binarization
output=im2bw(output,0.55);%0.55
%remove isolated regions
area=round(0.0005*M*N);
output=bwareaopen(output,area,8);
%opening image to remove isolated regions holes
%closing for fill holes
output=imclose(output,ones(7));
end