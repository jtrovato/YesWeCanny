% Function to compute Canny Edges
function E = cannyEdge(I)

% pad the image
r = 2;
Ip = padIm(I, r);

% smooth the image with Gaussian Blur
G = fspecial('gaussian', [3,3], 0.5);
Is = conv2(Ip, G, 'same');

% compute the gradient, magnitude, direction
dx = [1 -1];
dy = dx';
Jx = conv2(Is, dx, 'same');
Jy = conv2(Is, dy, 'same');

J_mag = sqrt(Jx.^2 + Jy.^2)
J_dir = atan2(Jx, Jy)

E = 0;
 

end
