function circle=getCircleMask(B)
circle=false(B,B);
for i=1:B
    for j=1:B
        if norm([i-(B+1)/2,j-(B+1)/2])<=B/2
            circle(i,j)=true;
        end
    end
end
end