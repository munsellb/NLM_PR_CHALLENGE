function text( A, varargin )
%
%
%
%
%
%
%

debug = true;
show_fig = false;
save_masked_rgb = false;

error( nargchk(1,2,nargin) );

if length(varargin) == 1,
    
    opts = varargin{1};
    
    if isfield( opts, 'debug'),
        debug = opts.debug;
    end;
    
    if isfield( opts, 'show_fig' ),
        show_fig = opts.show_fig;
    end;
    
    if isfield( opts, 'save_masked_rgb' ),
        save_masked_rgb = opts.save_masked_rgb;
    end;
end;

Transform_File = [ A.path '/Transform.mat' ];
Pill_Resolution_Mask = [ A.path '/mask_bI.jpg' ];
Square_Resolution_Mask = [ A.path '/mask_bW.jpg' ];
Pill_RGB_Image = [ A.path '/' A.img ];
Pill_RGB_Mask = [ A.path '/mask_rgb.jpg' ];

load( Transform_File );

bI(:,:,1) = uint8( im2bw( imread( Pill_Resolution_Mask ) ) );
bI(:,:,2) = bI(:,:,1);
bI(:,:,3) = bI(:,:,1);

bW=im2bw( imread( Square_Resolution_Mask ) );

I=imread( Pill_RGB_Image );

[M,N,~]=size(I);

Tx = 0;
Ty = 0;

if floor( T.x_mean ) < (N/2)
    Tx=(T.S/T.d_max)*(N/2-T.x_mean);
end;

if floor( T.y_mean ) < (M/2),
    Ty=(T.S/T.d_max)*(M/2-T.y_mean);
end;

if debug,
    fprintf('M=%d - %.4f, N=%d - %.4f\n', M/2, T.y_mean, N/2, T.x_mean);
    fprintf('Tx=%.4f, Ty=%.4f\n', Tx, Ty);
end;

A = [ (T.S/T.d_max) 0 0; 0 (T.S/T.d_max) 0; Tx Ty 1];

tform = maketform('affine', A );

TI = imtransform( (I.*bI), tform );

start_M = floor( ( T.M - size(TI,1) ) / 2 );
start_N = floor( ( T.N - size(TI,2) ) / 2 );

if start_M == 0,
    start_M = 1;
end;

if start_N == 0,
    start_N = 1;
end;

if debug,
    fprintf('TI (%d,%d)\n', size(TI,1), size(TI,2) );
    fprintf('start_M = %d, start_N = %d\n', start_M, start_N );
end;

TII = uint8( zeros( T.M, T.N, 3 ) );

if ( start_M >= 0 ) && ( start_N >= 0 ),
    
    if debug,
        fprintf('[Case 1] M and N are larger\n');
    end;

    TII( start_M:(start_M + size(TI,1)-1), start_N:(start_N + size(TI,2)-1), : ) = TI;
   
elseif ( start_M >= 0 ) && ( start_N < 0 ),
    
    if debug,
        fprintf('[Case 2] M larger and N smaller\n');
        fprintf('%d:%d\n', abs(start_N), (size(TI,2)+start_N) );
    end;
    
    idx_end = size(TI,2) + start_N;
    
    delta = idx_end + abs( start_N );
    
    if mod( delta, 2 ) == 0,
    
        idx_end = idx_end - 1;
    
    end;
    
    TII( start_M:(start_M + size(TI,1)-1), :, : ) = TI( :, abs(start_N):(idx_end), : );
    
elseif ( start_M < 0 ) && ( start_N >= 0 ),
    
    if debug,
        fprintf('[Case 3] M smaller and N larger\n');
    end;
    
    idx_end = size(TI,1) + start_M;
    
    delta = idx_end + abs( start_M );
    
    if mod( delta, 2 ) == 0,
        
        idx_end = idx_end - 1;
        
    end;
    
    TII( :, start_N:(start_N + size(TI,2)-1), : ) = TI( abs(start_M):(idx_end), :, : );
    
else,
    
    idx_end_m = size(TI,1) + start_M;
    delta_m = idx_end_m + abs( start_M );
    
    if mod( delta_m, 2 ) == 0,
        
        idx_end_m = idx_end_m - 1;
        
    end;
    
    idx_end_n = size(TI,2) + start_N;
    delta_n = idx_end_n + abs( start_N );
    
    if mod( delta_n, 2 ) == 0,
        
        idx_end_n = idx_end_n - 1;
        
    end;
    
    if debug,
        fprintf('[Case 4] M smaller and N smaller\n');
        fprintf('%d:%d\n', abs(start_M), (idx_end_m) );
        fprintf('%d:%d\n', abs(start_N), (idx_end_n) );
    end;
    
    TII = TI( abs(start_M):(idx_end_m), abs(start_N):(idx_end_n), : );
    
end;

if show_fig,
    figure;
    subplot( 1,2,1 ); imshow( bW ); title('scaled mask');
    subplot( 1,2,2 ); imshow( TII ); title('resized image');
end;

if save_masked_rgb,
    imwrite( TII, Pill_RGB_Mask, 'JPEG');
end;


