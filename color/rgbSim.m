function sim=rgbSim(i1,i2,m1,m2)

  %% TAKES COSINE DIST OF VEC OF MEDIAN COLOR

  % load images
  m1 = imread(m1);
  m2 = imread(m2);
  i1 = imread(i1);
  i2 = imread(i2);

  % take third channel of mask
  m1 = m1(:,:,3);
  m2 = m2(:,:,3);

  % split color channels for images
  r1 = i1(:,:,1);
  g1 = i1(:,:,2);
  b1 = i1(:,:,3);
  r2 = i2(:,:,1);
  g2 = i2(:,:,2);
  b2 = i2(:,:,3);

  % take mean of masked values
  red_mode1 = mean(i1(m1 ~=0));
  green_mode1 = mean(g1(m1 ~=0));
  blue_mode1 = mean(b1(m1 ~=0));
  red_mode2 = mean(r2(m2 ~=0));
  green_mode2 = mean(g2(m2 ~=0));
  blue_mode2 = mean(b2(m2 ~=0));
  rgb1 = [red_mode1 green_mode1 blue_mode1];
  rgb2 = [red_mode2 green_mode2 blue_mode2];

  rgb1 = rgb1 / 255;
  rgb2 = rgb2 / 255;

  %% saving reference files
  out1(1:500,1:500,1) = rgb1(1);
  out1(1:500,1:500,2) = rgb1(2);
  out1(1:500,1:500,3) = rgb1(3);

  out2(1:500,1:500,1) = rgb2(1);
  out2(1:500,1:500,2) = rgb2(2);
  out2(1:500,1:500,3) = rgb2(3);

  imwrite(out1,'color1.png','png');
  imwrite(out2,'color2.png','png');

  sim = 1- pdist2(rgb1,rgb2,'cosine');
