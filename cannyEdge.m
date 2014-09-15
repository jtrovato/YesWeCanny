% Function to compute Canny Edges
function E = cannyEdge(I)

% pad the image
nr = size(I,1);
nc = size(I,2);
pad = 2;
Ip = padIm(I, pad);

% smooth the image with Gaussian Blur
G = fspecial('gaussian', [5,5], 1.4);
Is = conv2(Ip, G, 'same');

% compute the gradient, magnitude, direction
% could simply use [Jmag, Jdir] = imgradient(Is);
dx = [1 -1];
dy = dx';
Jx = conv2(Ip, dx, 'same');
Jy = conv2(Ip, dy, 'same');
figure();
imagesc(Jx);
colormap(gray);
figure();
imagesc(Jy);
colormap(gray);


%no idea why we convolve with S
S = [1 1];
Jx = conv2(Jx, S, 'same');
Jy = conv2(Jy, S', 'same');

J_mag = sqrt(Jx.^2 + Jy.^2);
J_mag_norm = (J_mag-min(min(J_mag)))/(max(max(J_mag))-min(min(J_mag))); %normalize the magnitudes so thresholding is easier
J_dir = atan2d(Jy, Jx);
E_dir = atan2d(-Jx, Jy);


% Non-maximum supression: thinning out the edges
% using an interpolation algorithm from wikipedia. It uses four points
% instead of two closest to the gradient direction.
E = zeros(nr+2*pad, nc+2*pad);
for i = 2: size(J_dir, 1)-1;
    for j = 2:size(J_dir, 2)-1;
        theta = J_dir(i, j);
        if theta<0
            theta= theta + 360;
        end
        mag = J_mag(i,j);
            if (theta >= 0 && theta < 45) || (theta >= 180 && theta < 225)
                sam1 = 0.5*(J_mag(i-1,j+1) + J_mag(i, j+1));
                sam2 = 0.5*(J_mag(i, j-1) + J_mag(i+1, j-1));
                E(i,j) = J_mag_norm(i,j)*(mag > sam1 && mag > sam2);
            elseif  (theta >= 45 && theta < 90) || (theta >= 225 && theta < 270)
                sam1 = 0.5*(J_mag(i-1,j) + J_mag(i-1, j+1));
                sam2 = 0.5*(J_mag(i+1, j-1) + J_mag(i+1, j));
                E(i,j) = J_mag_norm(i,j)*(mag > sam1 && mag > sam2);
            elseif  (theta >= 90 && theta < 135) || (theta >= 270 && theta < 315)
                sam1 = 0.5*(J_mag(i-1, j-1) + J_mag(i-1, j));
                sam2 = 0.5*(J_mag(i+1, j) + J_mag(i+1, j+1));
                E(i,j) = J_mag_norm(i,j)*(mag > sam1 && mag > sam2);
            elseif  (theta >= 135 && theta < 180) || (theta >= 315 && theta <= 360)
                sam1 = 0.5*(J_mag(i-1, j-1) + J_mag(i, j-1));
                sam2 = 0.5*(J_mag(i, j+1) + J_mag(i+1, j+1));
                E(i,j) = J_mag_norm(i,j)*(mag > sam1 && mag > sam2);
            else
                error('thats an invalid angle');
            end
    end
end

figure(); imagesc(E); colormap(gray);

% hysteresis: connecting the edges
thres_high = 0.2;
thres_low = 0.01;

for i=1:size(E, 1);
    for j =1:size(E,2);
        if E(i,j) > thres_high
            E(i,j) = 1;
        elseif E(i,j) > thres_low
            if E(i-1:i+1,j-1:j+1)
                E(i,j) = 1;
            else
                E(i,j) = 0;
            end
        else
            E(i,j) = 0;
        end
    end
end
            


end
