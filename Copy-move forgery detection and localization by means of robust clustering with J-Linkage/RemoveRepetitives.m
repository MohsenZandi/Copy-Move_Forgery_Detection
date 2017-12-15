function out=RemoveRepetitives(input)
% degree = min number of repetition
% Remove Repetitive Vectors
out=sortrows(input);
[n,~]=size(out);
index=false(1,n);
i=1;
while (i<=n)
    index(i)=1;
    for j=i+1:n
        if any(out(i,1:2)~=out(j,1:2))
            break;
        end
    end
    i=j;
end
out=out(index,:);
end
