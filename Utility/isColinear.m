function out=isColinear(x,y,z)
x1=[x,1];
y1=[y,1];
z1=[z,1];
out=norm(cross(x1-z1,y1-z1))<eps;