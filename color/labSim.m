function sim=labSim(i1,i2,m1,m2)

  %% TAKES COSINE DIST OF VEC OF MEDIAN COLOR

  % load images
  m1 = imread(m1);
  m2 = imread(m2);
  i1 = rgb2lab(imread(i1));
  i2 = rgb2lab(imread(i2));

  % take third channel of mask
  m1 = m1(:,:,3);
  m2 = m2(:,:,3);

  % split color channels for images
  L1 = i1(:,:,1);
  a1 = i1(:,:,2);
  b1 = i1(:,:,3);
  L2 = i2(:,:,1);
  a2 = i2(:,:,2);
  b2 = i2(:,:,3);

  % take mean of masked values
  L1 = mean(L1(m1 ~=0));
  a1 = mean(a1(m1 ~=0));
  b1 = mean(b1(m1 ~=0));
  L2 = mean(L2(m2 ~=0));
  a2 = mean(a2(m2 ~=0));
  b2 = mean(b2(m2 ~=0));

  out1(1:500,1:500,1) = L1;
  out1(1:500,1:500,2) = a1;
  out1(1:500,1:500,3) = b1;

  out2(1:500,1:500,1) = L2;
  out2(1:500,1:500,2) = a2;
  out2(1:500,1:500,3) = b2;

  imwrite(lab2rgb(out1),'lcolor1.png','png');
  imwrite(lab2rgb(out2),'lcolor2.png','png');


  %% CIE LAB FORMULA 197*
  sim = 1 - sqrt((L1-L2).^2 + (a1-a2).^2 + (b1-b2).^2) / 255;
