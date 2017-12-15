%With help of Amir Tahmasbi Code ( Zernike Moments): http://www.utdallas.edu/~a.tahmasbi/research.html
function result=getHstar(n,l,siz)

x = 1:siz;
y = x;
[X,Y] = meshgrid(x,y);
c=(1+siz)/2;%Center
X=(X-c)/(c-1);
Y=(Y-c)/(c-1);
R = sqrt(X.^2+Y.^2);
Theta = atan2(Y,X);

%Test2-1
% N = siz;
% x = 1:N; y = x;
% [X,Y] = meshgrid(x,y);
% R = sqrt((2.*X-N-1).^2+(2.*Y-N-1).^2)/N;
% Theta=atan2(2.*Y-N-1,2.*X-N-1);

mask=(R<=1);
result=mask.*cos(pi*n*R.^2).*exp(-1i*l*Theta);
end