function d=textCompare2( A, B, ang )
%
%
%
%
%
%
%

PIX_NUDGE = 10;

show_cputime = false;

error( nargchk( 3, 3, nargin ) );

if show_cputime, tt = cputime; end;

Ia = imread( [ A.path '/mask_rgb.jpg' ] );
Iaa = imresize( Ia, 0.25 );

Ib = imread( [ B.path '/mask_rgb.jpg' ] );

Ma = im2bw( imread( [ A.path '/mask_bW.jpg' ] ) );
Maa = imresize( Ma, 0.25 );

IDX = ind2sub( size(Ma), find( Ma > 0 ) );
IDXa = ind2sub( size(Maa), find( Maa > 0 ) );

Xb = nudge( Ib, PIX_NUDGE );

d = 0;
idd = 0;

for i=1:length( Xb ),

    Zb_r1 = imrotate( Xb{i}.I, ang, 'crop' );
    Zb_r2 = imrotate( Xb{i}.I, (ang+180), 'crop' );
    dd = computeSim( Iaa, Zb_r1, Zb_r2, IDXa );

    if dd > d, d = dd; idd=i; end;

end;

Ib = imtransform( Ib, Xb{idd}.tform, 'XData',[1 size(Ib,2)], 'YData',[1 size(Ib,1)] );
Zb_r1 = imrotate( Ib, ang, 'crop' );
Zb_r2 = imrotate( Ib, (ang+180), 'crop' );

d = computeSim( Ia, Zb_r1, Zb_r2, IDX );

if show_cputime, fprintf('(text compare) total time = %.4f sec\n', cputime-tt ); end;

% -----------------------------
%
% helper function
%
%
function delta = computeSim( Za, Zb, Zbb, IDX )

N = 255;

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

delta(1) = 1 - sqrt( sum( (La-Lb).^2 ) + sum( (Aa-Ab).^2 ) + sum( (Ba-Bb).^2) ) / ( N*length(IDX) );
delta(2) = 1 - sqrt( sum( (La-Lbb).^2 ) + sum( (Aa-Abb).^2 ) + sum( (Ba-Bbb).^2) ) / ( N*length(IDX) );

delta = max( delta );
