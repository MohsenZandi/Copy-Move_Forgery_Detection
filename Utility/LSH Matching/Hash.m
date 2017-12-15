%Using Random LSH
%if a is a matrix then out is a vector
function out=Hash(x,a,b,r)
[~,p,q]=size(a);
[n,~]=size(x);
out=zeros(n,p,q);
for k=1:q
    out(:,:,k)=floor((x*a(:,:,k)+repmat(b(:,:,k),[n,1]))/r);
end
end