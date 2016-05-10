function sim=compareColors(c1,c2)
  %% compare two color files using the CIE76 color difference metric
  %% c1 and c2 are paths to color file
  %% i.e. /:pillId/color.png

  %% returns similarity between the two colors
  %% 1 is a perfect match

  
  % load images
  c1 = rgb2lab(imread(c1));
  c2 = rgb2lab(imread(c2));



  % split color channels for images
  L1 = c1(:,:,1);
  a1 = c1(:,:,2);
  b1 = c1(:,:,3);
  L2 = c2(:,:,1);
  a2 = c2(:,:,2);
  b2 = c2(:,:,3);

  %% CIE LAB FORMULA 197*
  sim = 1 - sqrt((L1-L2).^2 + (a1-a2).^2 + (b1-b2).^2) / 255;
  sim = sim(1);
