function D = rmbg( RGB )
%
%   Usage: bW = rmbg( RGB )
%
%
%
%
%
%
%

debug = false;

M_REF = 2400;

if size(RGB,2) ~= 2400,
    M_RGB_SX = M_REF/size(RGB,2);
    RGB = imresize( RGB, M_RGB_SX );
end;

[M,N,~]=size(RGB);

RGB = imresize( RGB, 0.2 );

O_RGB = RGB;

[MM,NN,~]=size(RGB);

PIX = NN;

if MM < NN, PIX = MM; end;

TT = floor( PIX * .39 );

H = fspecial('disk', 2);
RGB = imfilter( RGB, H, 'replicate' );

TOP=RGB(1:TT,:,:);
BTM=RGB(end-TT:end,:,:);

LFT=RGB(:,1:TT,:);
RGT=RGB(:,end-TT:end,:,:);

medbgclr(1,:) = uint8( medPixColorNotBlack( TOP ) );
medbgclr(2,:) = uint8( medPixColorNotBlack( BTM ) );
medbgclr(3,:) = uint8( medPixColorNotBlack( LFT ) );
medbgclr(4,:) = uint8( medPixColorNotBlack( RGT ) );

for i=1:size( medbgclr,1 ),
    
    RGB = subbkgnd( RGB, medbgclr(i,:) );
    RGB = imdilate( RGB, strel( 'disk', 4 ) );
    RGB = imerode( RGB, strel( 'disk', 3 ) );

end;

RGB = imdilate( RGB, strel( 'disk', 20 ) );
RGB = imerode( RGB, strel( 'disk', 18 ) );

bI = im2bw( mkBin( RGB ) );
CC = bwconncomp( bI );
OBJ = regionprops(CC, 'basic');

bI_area = size(bI,1)*size(bI,2);
bI_cm = [ size(bI,1)/2 size(bI,2)/2 ];

Mtx = zeros( length( OBJ ), 2 );
        
for i=1:length( OBJ ),

    aa = OBJ(i).Area;
    cm = OBJ(i).Centroid;

    Mtx(i,1) = aa / bI_area;
    Mtx(i,2) = pdist( [ cm ; bI_cm ], 'euclidean' );

end;

[~,idd]=sortrows( Mtx, [2 -1] );
bW = false( size( RGB(:,:,1) ) );
bW( CC.PixelIdxList{ idd(1) } ) = true;
bW = uint8( bW );


D = imresize( bW, [M N] );


if debug,

    figure; 
    
    Z(:,:,1) = bW;
    Z(:,:,2) = bW;
    Z(:,:,3) = bW;
    
    subplot( 1,3,1 ); imshow( O_RGB );
    subplot( 1,3,2 ); imshow( O_RGB.*uint8(Z) );
    subplot( 1,3,3 ); imshow( bW, [] );

end;


% -------------------------------------------------
%
% Helper functions
%
%

function W = mkBin( RGB )

mbg = medPixColorNotBlack( RGB );

W = uint8( zeros( size(RGB,1), size(RGB,2), 3 ) );

R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);

IDX_W_R = find( R >= mbg(1) );
IDX_W_G = find( G >= mbg(2) );
IDX_W_B = find( B >= mbg(3) );

IDX = union( IDX_W_R, IDX_W_G);
IDX = union( IDX, IDX_W_B );

R = W(:,:,1);
G = W(:,:,2);
B = W(:,:,3);

R(IDX) = 255;
G(IDX) = 255;
B(IDX) = 255;

W(:,:,1) = ( R );
W(:,:,2) = ( G );
W(:,:,3) = ( B );


function RGB = subbkgnd( RGB, bgclr )
%
%
%
%
%

[MM,NN,~]=size( RGB );

BG = uint8( ones( MM, NN, 3 ) );

BG(:,:,1) = BG(:,:,1).*bgclr(1);
BG(:,:,2) = BG(:,:,2).*bgclr(2);
BG(:,:,3) = BG(:,:,3).*bgclr(3);

P = probMap( RGB, BG );

IDX = find( P > 0.98 );

R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);

R(IDX) = 0;
G(IDX) = 0;
B(IDX) = 0;

RGB(:,:,1) = R;
RGB(:,:,2) = G;
RGB(:,:,3) = B;


function P = probMap( RGB, BG )

N = sqrt( 100^2 + 220^2 + 220^2 );

G = rgb2gray( RGB );
IDX = find( G == 0 );

A = rgb2lab( RGB );
B = rgb2lab( BG );

La = A(:,:,1);
Aa = A(:,:,2);
Ba = A(:,:,3);

Lb = B(:,:,1);
Ab = B(:,:,2);
Bb = B(:,:,3);

P = ones( size(La,1), size(La,2) ) - ( sqrt( (La-Lb).^2 + (Aa-Ab).^2 + (Ba-Bb).^2 ) / N );
P( IDX ) = 0;


function rgb = medPixColorNotBlack( I )
%
%
%
%
%
%

X = rgb2gray( I );
IDX = find( X > 10 );

if ~isempty( IDX ),

    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    rgb(1) = double( median( R( IDX ) ) );
    rgb(2) = double( median( G( IDX ) ) );
    rgb(3) = double( median( B( IDX ) ) );

else,
    rgb = zeros(1,3);
end;
