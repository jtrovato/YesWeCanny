function I_padded = padIm(I, border)

[nr, nc, nb] = size(I);
%I_padded = zeros(nr+2*border, nc+2*border, nb);
%I_padded(border+1:border+nr, border+1:border+nc) = I;

border_l = I(:,border+1:-1:2,:);
border_r = I(:,nc-1:-1:nc-border,:);
I = [border_l,I,border_r];
border_t = I(border+1:-1:2,:,:);
border_b = I(nr-1:-1:nr-border,:,:);
I = [border_t;I;border_b];

I_padded = I;

