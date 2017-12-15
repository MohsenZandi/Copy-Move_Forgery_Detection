%Sorting
FeatureMatrix=sortrows(FeatureMatrix,1:FVsize);
%Matching Similar Blocks & Filtering by Blocks Distance
mask=false(M,N);%ultimate mask of copy-move regions
matchlist=[];
dot=B;
min_th=0;
max_th=0.09;
Similarity_factor=(max_th-min_th)/(max_std);
for u=1:num_blocks
    search_depth=min(num_blocks-u,search_th);%num_blocks-u == number of remain blocks
    threshold=Similarity_factor*FeatureMatrix(u,FVsize+3)+min_th;
    for v=1:search_depth
        if norm(FeatureMatrix(u,FVsize+1:FVsize+2)-FeatureMatrix(u+v,FVsize+1:FVsize+2))>MinDistance %filtering by Distance Of Blocks -- filter near blocks
            if norm(FeatureMatrix(u,1:FVsize)-FeatureMatrix(u+v,1:FVsize))<= threshold %Similarity_th %filtering by Similarity measure
                % u and u+v  are similar
                % mark in mask image
                mask(FeatureMatrix(u,FVsize+1):FeatureMatrix(u,FVsize+1)+dot-1,FeatureMatrix(u,FVsize+2):FeatureMatrix(u,FVsize+2)+dot-1)=1;
                mask(FeatureMatrix(u+v,FVsize+1):FeatureMatrix(u+v,FVsize+1)+dot-1,FeatureMatrix(u+v,FVsize+2):FeatureMatrix(u+v,FVsize+2)+dot-1)=1;
            end
        end
    end
end
% %remove isolated regions
% area=round(0.001*M*N);
% mask=bwareaopen(mask,area,4);
% %Closing for fill holes
% mask=imclose(mask,[1 1 1;1 1 1; 1 1 1]);

%Mark Ultimate Result
ultimate=RGBimage;
red_channel=RGBimage(:,:,1);
green_channel=RGBimage(:,:,2);
blue_channel=RGBimage(:,:,3);
red_channel(mask(:))=255;
green_channel(mask(:))=255;
blue_channel(mask(:))=255;
ultimate(:,:,1)= red_channel;
ultimate(:,:,2)= green_channel;
ultimate(:,:,3)= blue_channel;
%show ultimate result
imshow(ultimate);
title('Ultimate Result');
toc%print elapsed time