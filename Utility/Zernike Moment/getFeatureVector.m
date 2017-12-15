function FeatureVector=getFeatureVector(block,FVsize,Vstars)
% Write your feature extraction algorithm!
FeatureVector=zeros(1,FVsize);
FeatureVector(1)= Zernikmoment(block,Vstars(:,:,1),0);
[FeatureVector(2),FeatureVector(13)]= Zernikmoment(block,Vstars(:,:,2),1);
FeatureVector(3)= Zernikmoment(block,Vstars(:,:,3),2);
FeatureVector(4)= Zernikmoment(block,Vstars(:,:,4),2);
FeatureVector(5)= Zernikmoment(block,Vstars(:,:,5),3);
FeatureVector(6)= Zernikmoment(block,Vstars(:,:,6),3);
FeatureVector(7)= Zernikmoment(block,Vstars(:,:,7),4);
FeatureVector(8)= Zernikmoment(block,Vstars(:,:,8),4);
FeatureVector(9)= Zernikmoment(block,Vstars(:,:,9),4);
FeatureVector(10)= Zernikmoment(block,Vstars(:,:,10),5);
FeatureVector(11)= Zernikmoment(block,Vstars(:,:,11),5);
FeatureVector(12)= Zernikmoment(block,Vstars(:,:,12),5);
end