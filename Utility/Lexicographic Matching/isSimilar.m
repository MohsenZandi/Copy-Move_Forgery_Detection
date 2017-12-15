function ret=isSimilar(fv1,fv2,threshold)
ret=norm(fv1-fv2)<=threshold;
end