function [u, v, hitMap] = opticalFlow(I1, I2, windowSize, tau)
%I1= imread('data/corridor/bt.000.png');
%I1=(rgb2gray(I1));
img = im2double(I1);
%I2 = imread('data/corridor/bt.001.png');
%I2=(rgb2gray(I2));
im2 = im2double(I2);
%tau =1.38;
% Compute a gaussian kernel
sigma = 1;
%windowSize = 100;
gaussianWidth = 3*sigma;
x = -gaussianWidth:1:gaussianWidth;
gaussianKernel = 1/(sqrt(2*pi)*sigma)*exp(-.5*(x.^2)/sigma^2);
    
% Compute the gradient
smoothedXDerivativeKernel = conv2(gaussianKernel, [-1/2 0 1/2]);
smoothedYDerivativeKernel = smoothedXDerivativeKernel';
Ix = conv2(img, smoothedXDerivativeKernel, 'same');
Iy = conv2(img, smoothedYDerivativeKernel, 'same');
It = im2 - img;
    
% Compute sums of Ix^2, Iy^2, and Ix*Iy over a windowSizeXwindowSize
% neighborhood
sum_Ix_sqr = conv2(Ix.^2, ones(windowSize), 'same'); 
sum_Iy_sqr = conv2(Iy.^2, ones(windowSize), 'same'); 
sum_Ix_Iy  = conv2(Ix.*Iy, ones(windowSize), 'same');
sum_Ix_It  = conv2(Ix.*It, ones(windowSize), 'same');
sum_Iy_It  = conv2(Iy.*It, ones(windowSize), 'same');
sum_It  = conv2(It, ones(windowSize), 'same');
    
% Compute the matrix of smallest singular values lambda2 for each 
% pixel location.  Here, C=[sum_Ix_sqr,sum_Ix_Iy;sum_Ix_Iy,sum_Iy_sqr].
% Since C is just a 2X2 matrix, we can compute this singular value
% analytically in closed form, for all pixels simultaneously
trace_C = sum_Ix_sqr + sum_Iy_sqr;
determinant_C = sum_Ix_sqr.*sum_Iy_sqr - sum_Ix_Iy.*sum_Ix_Iy;
lambda2 = .5*(trace_C - sqrt(trace_C.^2 - 4*determinant_C));

hitMap = lambda2 > tau;

u=zeros(size(hitMap,1),size(hitMap,2));
v=zeros(size(hitMap,1),size(hitMap,2));
%ainv=(sum_Ix_sqr.*sum_Iy_sqr - sum_Ix_Iy.*sum_Ix_Iy)/determinant_C(i,j);
for i=1:size(hitMap,1)
    for j=1:size(hitMap,2)
           if(hitMap(i,j)==1)
                C=[sum_Ix_sqr(i,j),sum_Ix_Iy(i,j);sum_Ix_Iy(i,j),sum_Iy_sqr(i,j)];
                uv=pinv(C)*[sum_Ix_It(i,j);sum_Iy_It(i,j)];
                %v(i,j)=-ainv(i,j)*sum_Iy_It(i,j);
                u(i,j)=uv(1);
                v(i,j)=uv(2);
           end
    end
end
%imshow(imresize(im2,[20,20]));
%{
u1=imresize(u,[20,20]);
v1=imresize(v,[20,20]);

[x,y] = meshgrid(1:20,1:20);
%figure,quiver(x,y,u1,v1);

figure,imshow(hitMap);
title('Valid area, windowsize: 100');
figure,quiver(u1,v1,1);
title('Needlemap, windowsize: 100');
set(gca,'YDir','reverse');
xlim([0,20]);
ylim([0,20]);
%}
