function FeatureVector=getFeatureVector(block,FVsize,kernels,param)
% Write your feature extraction algorithm!
FeatureVector=zeros(1,FVsize);
FeatureVector(1)=PCT(block,param(1,1),kernels(:,:,1));
[FeatureVector(2),FeatureVector(9)]=PCT(block,param(2,1),kernels(:,:,2));
FeatureVector(3)=PCT(block,param(3,1),kernels(:,:,3));
FeatureVector(4)=PCT(block,param(4,1),kernels(:,:,4));
FeatureVector(5)=PCT(block,param(5,1),kernels(:,:,5));
FeatureVector(6)=PCT(block,param(6,1),kernels(:,:,6));
FeatureVector(7)=PCT(block,param(7,1),kernels(:,:,7));
FeatureVector(8)=PCT(block,param(8,1),kernels(:,:,8));
end