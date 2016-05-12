function out = makeColorMat(im,mask)


  %%% takes the mean of the color of the masked area
  %%% of a pill image and returns a 250x250x3 solid matrix
  %%% of that color

  %%% Arguments :
    %% im : path to pill image
    %% mask : path to mask image

  %%% usage :   imwrite(makeColorMat(im,mask),'/:pillId/color.png','png');

  im_mat = rgb2lab(imread(im));
  mask = imread(mask);

  % take third channel of mask
  m = mask;

  % split color channels for images
  L = im_mat(:,:,1);
  a = im_mat(:,:,2);
  b = im_mat(:,:,3);

  % take mean of masked values
  L = mean(L(m ~=0));
  a = mean(a(m ~=0));
  b = mean(b(m ~=0));

  % build out matrix
  out(1:50,1:50,1) = L;
  out(1:50,1:50,2) = a;
  out(1:50,1:50,3) = b;

  out = lab2rgb(out);
