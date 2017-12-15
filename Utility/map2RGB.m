function UltimateResult = map2RGB(map,RGBimage,color)
red=RGBimage(:,:,1);
green=RGBimage(:,:,2);
blue=RGBimage(:,:,3);
red(map)=color(1);
green(map)=color(2);
blue(map)=color(3);
UltimateResult=RGBimage;
UltimateResult(:,:,1)=red;
UltimateResult(:,:,2)=green;
UltimateResult(:,:,3)=blue;
end

