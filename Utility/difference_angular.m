function out=difference_angular(alpha1,alpha2)
a1=mod(alpha1,360);
a2=mod(alpha2,360);
a1=a1+(a1<0).*360;
a2=a2+(a2<0).*360;
b1=abs(a1-a2);
b2=min(a1,a2)+360-max(a1,a2);
out=min(b1,b2);
end