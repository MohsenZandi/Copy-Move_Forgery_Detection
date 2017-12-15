function out=getRepetitives(input,degree)
% if degree==1
%     out=input;
%     return;
% end
% degree = min number of repetition
% Remove Repetitive Vectors
out=sortrows(input);
[n,~]=size(out);
index=false(1,n);
i=1;
while (i<=n)
    count=1;
    for j=i+1:n
        if all(out(i,:)==out(j,:))
            count=count+1;
        else
            break;
        end
    end   
    if count>=degree
        index(i)=1;
    end
    i=j;
end
out=out(index,:);
end
