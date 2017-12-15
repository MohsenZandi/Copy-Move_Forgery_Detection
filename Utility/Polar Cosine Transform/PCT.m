%Polar Cosine Transform
function  [Amp,Phi]= PCT(image,n,kernel)
Z=omega(n)*sum(sum(kernel.*image));
Amp = abs(Z);
Phi = angle(Z)*180/pi;
end

