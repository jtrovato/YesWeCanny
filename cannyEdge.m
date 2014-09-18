% cannyEdge.m
% Joseph J Trovato, Justin K Yim
% September 2014
% 
% CIS 581: Computer Vision & Computational Photography
% Project 1: Edge Detection

% Function to compute Canny Edges
function E = cannyEdge(I)

% Handle color images
if size(I,3) > 1
    I = rgb2gray(I);
end

% pad the image
nr = size(I,1);
nc = size(I,2);
pad = 2;
Ip = double(padIm(I, pad));

% smooth the image with Gaussian Blur
G = fspecial('gaussian', [5,5], 1.4);
Is = conv2(Ip, G, 'same');

% compute the gradient, magnitude, direction
% could simply use [Jmag, Jdir] = imgradient(Is);
dx = [1 -1];
dy = dx';
Jx = conv2(Is, dx, 'same');
Jy = conv2(Is, dy, 'same');

%{
% X and Y gradient display (debugging)
figure();
imshow(Jx./max(max(Jx)));
figure();
imshow(Jy./max(max(Jy)));
%}

% Smoothing opposite direction of gradient
S = [1; 1];
Jx = conv2(Jx, S, 'same');
Jy = conv2(Jy, S', 'same');

J_mag = sqrt(Jx.^2 + Jy.^2);
J_mag_norm = (J_mag-min(min(J_mag)))/(max(max(J_mag))-min(min(J_mag))); %normalize the magnitudes so thresholding is easier
J_dir = atan2d(-Jy, Jx);

%{
% Total gradient display (debugging)
figure();
imagesc(J_mag); colormap('gray'); axis equal
hold on
quiver(Jx, Jy);
hold off
%}

% Non-maximum supression: thinning out the edges
% using an interpolation algorithm from wikipedia. It uses four points
% instead of two closest to the gradient direction.
J_mag_supp = zeros(nr+2*pad, nc+2*pad);
for ii = 2: size(J_dir, 1)-1;
    for jj = 2:size(J_dir, 2)-1;
        theta = J_dir(ii, jj);
        if theta<0
            theta= theta + 360;
        end
        mag = J_mag(ii,jj);
            if (theta >= 0 && theta < 45) || (theta >= 180 && theta < 225)
                sam1 = 0.5*(J_mag(ii-1,jj+1) + J_mag(ii, jj+1));
                sam2 = 0.5*(J_mag(ii, jj-1) + J_mag(ii+1, jj-1));
            elseif  (theta >= 45 && theta < 90) || (theta >= 225 && theta < 270)
                sam1 = 0.5*(J_mag(ii-1,jj) + J_mag(ii-1, jj+1));
                sam2 = 0.5*(J_mag(ii+1, jj-1) + J_mag(ii+1, jj));
            elseif  (theta >= 90 && theta < 135) || (theta >= 270 && theta < 315)
                sam1 = 0.5*(J_mag(ii-1, jj-1) + J_mag(ii-1, jj));
                sam2 = 0.5*(J_mag(ii+1, jj) + J_mag(ii+1, jj+1));
            elseif  (theta >= 135 && theta < 180) || (theta >= 315 && theta <= 360)
                sam1 = 0.5*(J_mag(ii-1, jj-1) + J_mag(ii, jj-1));
                sam2 = 0.5*(J_mag(ii, jj+1) + J_mag(ii+1, jj+1));
            else
                error('thats an invalid angle');
            end
            J_mag_supp(ii,jj) = J_mag_norm(ii,jj)*(mag > sam1 && mag > sam2);
    end
end

% Hysteresis: connecting the edges

% Thresholds
pixel_list = reshape(J_mag_supp,1,numel(J_mag_supp));
thres_high = mean(pixel_list) + 1.2*std(pixel_list);%0.08;
thres_low = mean(pixel_list) + 0.5*std(pixel_list);

%disp(['mean: ',num2str(mean(pixel_list)),' std: ',num2str(std(pixel_list))]);

J_mag_sized = J_mag_supp(3:(end-2),3:(end-2));
E = J_mag_sized > thres_high;

for ii = 1:numel(E)
    low = J_mag_sized > thres_low;
    hyst = conv2(single(E),ones(3,3),'same');
    new = (low & hyst) & ~E;
    if all(all(~new))
        break
    end
    E = E | new;

end

%{
% Gradient histograms for auto threshold set (debugging)
figure
hist(reshape(J_mag_sized,1,numel(J_mag_sized)),100)
std(reshape(J_mag_sized,1,numel(J_mag_sized)))
%}


end
