function text()

load Transform;


bI(:,:,1) = uint8( im2bw( imread('mask_bI.jpg') ) );
bI(:,:,2) = bI(:,:,1);
bI(:,:,3) = bI(:,:,1);

bW=im2bw( imread('mask_bW.jpg') );

I=imread('00002-3228-30_PART_1_OF_1_CHAL10_SB_391E1C80.jpg');

[M,N,Z]=size(I);

Tx=(T.S/T.d_max)*(N/2-T.x_mean);
Ty=(T.S/T.d_max)*(M/2-T.y_mean);

fprintf('M=%d - %.4f, N=%d - %.4f\n', M/2, T.y_mean, N/2, T.x_mean);
fprintf('Tx=%.4f, Ty=%.4f\n', Tx, Ty);

A = [ (T.S/T.d_max) 0 0; 0 (T.S/T.d_max) 0; Tx Ty 1];

tform = maketform('affine', A );

TI = imtransform( (I.*bI), tform );

start_M = floor( ( T.M - size(TI,1) ) / 2 );
start_N = floor( ( T.N - size(TI,2) ) / 2 );

TII = uint8( zeros(T.M,T.N,3) );

TII( start_M:(start_M + size(TI,1)-1),start_N:(start_N + size(TI,2)-1),:) = TI;

figure;
subplot( 1,2,1 ); imshow( bW ); title('scaled mask');
subplot( 1,2,2 ); imshow( TII ); title('resized image');

imwrite( TII, 'tt.jpg', 'JPEG');


