function [a,b] = MakeBuckets(Vsize,p,q,r)
a=random('normal',0,1,[Vsize,p,q]);
b=r*rand(1,p,q);
end
