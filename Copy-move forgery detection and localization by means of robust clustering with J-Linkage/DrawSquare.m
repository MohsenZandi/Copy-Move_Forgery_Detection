%Draw a square around pixel
%
% INPUTS:
%   x,y                - coordinates of pixel
%   length         - size of square
%   color          -color of square

% ---
% Programmer: Mohsen Zandi
% Student of Master of Engineering - Artifical Intelligence
% Faculty of Electrical and Computer Engineering
% Shahid Beheshti University
% 2013
function  DrawSquare(x,y,length,color)
L=length/2;
line([x-L,x+L,x+L,x-L,x-L],...
     [y-L,y-L,y+L,y+L,y-L],...
     'color',color);
end

