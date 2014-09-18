% script to test cannyEdge()
close all;

%{
I = [1 1 .5 1 0 .5 .5 1 0 1 0;
    0 1 .5 1 0 .5 .5 1 0 1 1;
    0 1 .5 1 0 .5 .5 1 0 1 1;
    1 1 0 1 0 0 0 1 1 0 0;
    .5 .5 0 .5 1 1 1 1 1 0 0;
    .5 .5 .5 .5 .5 .5 1 1 1 0 0;
    0 0 .5 .5 0 .5 1 1 0 0 1]; 

% uncomment to test on a real image
I = imread('test1.jpg');
%I = rgb2gray(I);
%}

figure();
imshow(I);

E = cannyEdge(I);

figure();
imshow(E);

if size(I,3) > 1
    I2 = rgb2gray(I);
else
    I2 = I;
end
figure; imshow(edge(I2,'canny'))
