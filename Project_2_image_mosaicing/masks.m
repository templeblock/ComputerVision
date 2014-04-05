% Write a program which takes two images and automatically solves for the image warp.
% stitchedImage = stitch( im1, im2, homography), stitches images im1 and
% im2 using homography homography. Obtain homography from RANSAC
% Adina Stoica, Derek Burrows 2012, CSE 559A Computer Vision, Washington University in St. Louis
function [mask1, mask2] = masks( im1, im2, homography)

stitchedImage = im1;
stitchedImage = padarray(stitchedImage, [0 size(im2, 2)], 0, 'post');
stitchedImage = padarray(stitchedImage, [size(im2, 1) 0], 0, 'both');

mask1 = ones(size(im1));
mask1 = padarray(mask1, [0 size(im2, 2)], 0, 'post');
mask1 = padarray(mask1, [size(im2, 1) 0], 0, 'both');

mask2 = ones(size(mask1));

for i = 1:size(stitchedImage, 2)
    for j = 1:size(stitchedImage, 1)
        p2 = homography * [i; j-floor(size(im2, 1)); 1];
        p2 = p2 ./ p2(3);

        x2 = floor(p2(1));
        y2 = floor(p2(2));

        if x2 > 0 && x2 <= size(im2, 2) && y2 > 0 && y2 <= size(im2, 1)
            stitchedImage(j, i) = im2(y2, x2);
            mask2(j,i) = 0;
        end
    end
end

%crop
% [row,col] = find(stitchedImage);
% c = max(col(:));
% d = max(row(:));
% 
% st=imcrop(stitchedImage, [1 1 c d]);
% mask1=imcrop(mask1, [1 1 c d]);
% mask2=imcrop(mask2, [1 1 c d]);
% 
% [row,col] = find(stitchedImage ~= 0);
% a = min(col(:));
% b = min(row(:));
% st=imcrop(st, [a b size(st,1) size(st,2)]);
% mask1=imcrop(mask1, [a b size(st,1) size(st,2)]);
% mask2=imcrop(mask2, [a b size(st,1) size(st,2)]);
