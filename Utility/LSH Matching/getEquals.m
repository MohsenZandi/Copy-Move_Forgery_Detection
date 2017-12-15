%return index of Equal Vectors
function out=getEquals(vectors,Locations,distance_th)
[s,index]=sortrows(vectors);
[n,~]=size(s);
pre_siz=3000;
out_size=pre_siz;
out=zeros(pre_siz,2);
row=1;
for  i=1:n-1
    for j=i+1:n
        if all(s(i,:)==s(j,:))
            i1=index(i);
            i2=index(j);
            if norm(Locations(i1,:)-Locations(i2,:))>=distance_th
                if row>out_size
                    out=[out;zeros(pre_siz,2)];
                    out_size=out_size+pre_siz;
                end
                out(row,:)=[i1,i2];
                row=row+1;
            end
        else
            break;
        end
    end
end
out=out(1:row-1,:);
end