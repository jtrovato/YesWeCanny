% script to test cannyEdge()

I = [1 1 .5 1 0 .5 .5 1 0 1 0;
    0 1 .5 1 0 .5 .5 1 0 1 1;
    0 1 .5 1 0 .5 .5 1 0 1 1;
    1 1 0 1 0 0 0 1 1 0 0;
    .5 .5 0 .5 1 1 1 1 1 0 0;
    .5 .5 .5 .5 .5 .5 1 1 1 0 0;
    0 0 .5 .5 0 .5 1 1 0 0 1]; 

E = cannyEdge(I);

figure();
imagesc(E);
colormap('gray');