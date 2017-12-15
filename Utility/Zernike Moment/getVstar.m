% Copyright C 2012 Amir Tahmasbi
% The University of Texas at Dallas
% a.tahmasbi@utdallas.edu
% http://www.utdallas.edu/~a.tahmasbi/research.html
%
% License Agreement: You are free to use this code in your scientific
%                    research but you should cite the following papers:
%
% [1] - A. Tahmasbi, F. Saki, S. B. Shokouhi, 
%      	Classification of Benign and Malignant Masses Based on Zernike Moments, 
% 	J. Computers in Biology and Medicine, vol. 41, no. 8, pp. 726-735, 2011.
%
% [2] - A. Tahmasbi, F. Saki, H. Aghapanah, S. B. Shokouhi,
%	A Novel Breast Mass Diagnosis System based on Zernike Moments as Shape and Density Descriptors,
%	in Proc. IEEE, 18th Iranian Conf. on Biomedical Engineering (ICBME'2011), 
%	Tehran, Iran, 2011, pp. 100-104.
%
% -------------------------------------------------------------------------

% Edited By Mohsen Zandi

function V=getVstar(siz,n,m)
N = siz;
x = 1:N; y = x;
% c=(1+siz)/2;%Center
% X=(X-c)/(c-1);
% Y=(Y-c)/(c-1);
[X,Y] = meshgrid(x,y);
R = sqrt((2.*X-N-1).^2+(2.*Y-N-1).^2)/N;
Theta = atan2((N-1-2.*Y+2),(2.*X-N+1-2));
Mask = R<=1;
V = Mask.*radialpoly(R,n,m).*exp(-1i*m*Theta);
end