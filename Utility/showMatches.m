function showMatches(RGBimage,MatchList,Locations,B,color,showMap,showOrg,resultName)
mask=getCircleMask(B);
[M,N,~]=size(RGBimage);
num_matches=size(MatchList,1);
%Mark Each Match in Map (binary image)
map=false(M,N);
if(~isempty(MatchList))
    for i=1:num_matches
        u=MatchList(i,1);
        v=MatchList(i,2);
        x1=Locations(u,1);
        y1=Locations(u,2);
        x2=Locations(v,1);
        y2=Locations(v,2);
        map(y1:y1+B-1,x1:x1+B-1)=mask|map(y1:y1+B-1,x1:x1+B-1);
        map(y2:y2+B-1,x2:x2+B-1)=mask|map(y2:y2+B-1,x2:x2+B-1);
    end
end
%Create Ultimate Result
UltimateResult=RGBimage;
Red=RGBimage(:,:,1);
Green=RGBimage(:,:,2);
Blue=RGBimage(:,:,3);
Red(map(:))=color(1);
Green(map(:))=color(2);
Blue(map(:))=color(3);
UltimateResult(:,:,1)=Red;
UltimateResult(:,:,2)=Green;
UltimateResult(:,:,3)=Blue;

if showOrg==1
    figure;
    imshow(RGBimage);
    title('Original');
end
if showMap==1
    figure;
    imshow(map);
    title('Copy-Move Map');
end
figure;
imshow(UltimateResult);
title(resultName);
% if ~isempty( resultName )
%     imwrite(UltimateResult,resultName);%save result
% end