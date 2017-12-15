%Quad Core
function [FeatureMatrix,StandardDeviations]=getFeatureMatrix_parallel(grayimage,B,FVsize,Keypoint_Locations)
[M,N]=size(grayimage);
num_blocks=size(Keypoint_Locations,1);
temp=mod(num_blocks,4);
residue=(temp~=0)*(4-temp);
Keypoint_Locations=[Keypoint_Locations;...
    M/2*ones(residue,2)];
section_size=(num_blocks+residue)/4;
sub_Locations=zeros(section_size,2,4);
start_section=1;
for k=1:4
    sub_Locations(:,:,k)=Keypoint_Locations(start_section:start_section+section_size-1,:);
    start_section=start_section+section_size;
end
Mats=zeros(section_size,FVsize,4);%matrices for store result of parallel Feature Extraction
stds=zeros(section_size,1,4);
%start 4 thread for feature extraction of each sub image (parfor==parallel for)
parfor h=1:4
    [Mats(:,:,h),stds(:,:,h)]=getFeatureMatrix(grayimage,B,FVsize,sub_Locations(:,:,h));
end
FeatureMatrix=[Mats(:,:,1)  ;Mats(:,:,2)  ;Mats(:,:,3) ; Mats(:,:,4)];%create complete feature matrix
FeatureMatrix=FeatureMatrix(1:num_blocks,:);%Remove residue feature vectors from the end
% Locations=[locs(:,1,1)+sections(1,2),locs(:,2,1)+sections(1,1);...
%                    locs(:,1,2)+sections(2,2),locs(:,2,2)+sections(2,1);...
%                    locs(:,1,3)+sections(3,2),locs(:,2,3)+sections(3,1);...
%                    locs(:,1,4)+sections(4,2),locs(:,2,4)+sections(4,1)];
StandardDeviations=[stds(:,:,1);stds(:,:,2);stds(:,:,3);stds(:,:,4)];
StandardDeviations=StandardDeviations(1:num_blocks,:);
end