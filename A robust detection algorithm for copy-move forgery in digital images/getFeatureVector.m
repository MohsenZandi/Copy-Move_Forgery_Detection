function FeatureVector=getFeatureVector(block,q1,q2,q3,q4)
% Write your feature extraction algorithm!
dct_block=dct2(block);
FeatureVector=[sum(sum(q1.*dct_block)), sum(sum(q2.*dct_block)),sum(sum(q3.*dct_block)),sum(sum(q4.*dct_block))];
end