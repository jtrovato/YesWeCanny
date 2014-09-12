% script to test cannyEdge()

I = [1 1 .5 1 0 .5 .5 1 0 1 0;
    0 1 .5 1 0 .5 .5 1 0 1 1;
    0 1 .5 1 0 .5 .5 1 0 1 1;
    1 1 0 1 0 0 0 1 1 0 0;
    .5 .5 0 .5 1 1 1 1 1 0 0;
    .5 .5 .5 .5 .5 .5 1 1 1 0 0;
    0 0 .5 .5 0 .5 1 1 0 0 1]; 

% uncomment to test on a real image
I = imread('test.jpg');
I = rgb2gray(I);

E = cannyEdge(I);

figure(1);
imagesc(I);
colormap('gray');
figure(2);
imagesc(E);
colormap('gray');
