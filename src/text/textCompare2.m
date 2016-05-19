function d=textCompare2( A, B, ang )
%
%
%
%
%
%
%

error( nargchk(3,3,nargin) );

Ma(:,:,1) = im2bw( imread( [ A.path '/mask_bW.jpg' ] ) );
Ma(:,:,2) = Ma(:,:,1);
Ma(:,:,3) = Ma(:,:,1);
Ma =uint8( Ma );

Ia = imread( [ A.path '/mask_rgb.jpg' ] );

Mb(:,:,1) = uint8( im2bw( imread( [ B.path '/mask_bW.jpg' ] ) ) );
Mb(:,:,2) = Mb(:,:,1);
Mb(:,:,3) = Mb(:,:,1);
Mb =uint8( Mb );

Ib = imread( [ B.path '/mask_rgb.jpg' ] );

Za = Ma.*Ia;
Zb = Ib;

Zaa = squeeze( Za(:,:,1 ) );
IDX = ind2sub( size(Zaa), find( Zaa > 0 ) );

Zb_r1 = imrotate( Zb, ang, 'crop' );
Zb_r2 = imrotate( Zb, (ang+180), 'crop' );

d = computeSim( Za, Zb_r1, Zb_r2, IDX );

% -----------------------------
%
% helper function
%
%
function delta = computeSim( Za, Zb, Zbb, IDX )

delta = zeros(1,2);

Za = rgb2lab( Za );
Zb = rgb2lab( Zb );
Zbb = rgb2lab( Zbb );

La = Za(:,:,1);
Aa = Za(:,:,2);
Ba = Za(:,:,3);

La = La( IDX );
Aa = Aa( IDX );
Ba = Ba( IDX );

Lb = Zb(:,:,1);
Ab = Zb(:,:,2);
Bb = Zb(:,:,3);

Lb = Lb( IDX );
Ab = Ab( IDX );
Bb = Bb( IDX );

Lbb = Zbb(:,:,1);
Abb = Zbb(:,:,2);
Bbb = Zbb(:,:,3);

Lbb = Lbb( IDX );
Abb = Abb( IDX );
Bbb = Bbb( IDX );

delta(1) = 1 - sqrt( sum( (La-Lb).^2 ) + sum( (Aa-Ab).^2 ) + sum( (Ba-Bb).^2) ) / ( 255*length(IDX) );
delta(2) = 1 - sqrt( sum( (La-Lbb).^2 ) + sum( (Aa-Abb).^2 ) + sum( (Ba-Bbb).^2) ) / ( 255*length(IDX) );

delta = max( delta );

