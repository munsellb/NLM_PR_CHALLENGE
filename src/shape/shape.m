function [bI,bW,T]=shape( pill_img )
%
%   Usage: [bI,bW,T]=shape( pill_img )
%
%   Description: More to come :)
%
%   Return(s): RGB binary mask (bI), square binary mask (bW), and affine
%   transformation (T)
%
%   Arguments: 1 (string)
%              
%              pill_img = fully qualified path to reference or consumer
%                         color image
%
%   Example usage:
%   
%               [bI,bW,T]=shape( '/home/pill/pill_1.jpg' );
%
%
%

error( nargchk(1,1,nargin) );

M_REF = 2400;

M = 200;
N = 200;
F = floor( M/2 );
S = floor( M/5 );

view_mask = false;

RGB = imread( pill_img );

if size(RGB,2) ~= 2400,
    M_RGB_SX = M_REF/size(RGB,2);
    RGB = imresize( RGB, M_RGB_SX );
end;

fprintf('RGB Resolution (%d,%d)\n', size(RGB,1), size(RGB,2) );

G = medfilt2( rgb2gray( RGB ), [10 10] );

G = imadjust( histeq( G ) );

[cnt, bin] = imhist( G );

V = sortrows( [cnt bin], 1 );

[xbar,stdev] = threshold( V );

top_thresh = xbar + stdev;
btm_thresh = xbar - stdev;

fprintf('top_thres = %d\n', top_thresh );
fprintf('btm_thres = %d\n', btm_thresh );

idx_black = find( ( G >= btm_thresh ) & ( G <= top_thresh ) );
idx_white = find( ( G < btm_thresh ) | ( G > top_thresh ) );

bI = G;

bI(idx_black) = 0;
bI(idx_white) = 255;

bI = medfilt2( bI, [80 80] );

c = contourc( double( bI ), 2 );

P = parseContour( c, bI );

bI = poly2mask( P(:,1)',P(:,2)', size(bI,1), size(bI,2) );

x_mean = mean( P(:,1) );
y_mean = mean( P(:,2) );

Pc = P - repmat( [x_mean y_mean], size(P,1), 1 );

x_max = max( abs( Pc(:,1) ) );
y_max = max( abs( Pc(:,2) ) );

d_max = x_max;

if y_max > x_max, d_max = y_max; end;

Pc = ( Pc ./ d_max ) .* S + repmat( [F F], size(Pc,1), 1 );

T.d_max = d_max;
T.S = S;
T.F = F;
T.x_mean = x_mean;
T.y_mean = y_mean;
T.M = M;
T.N = N;

fprintf('mean x = %.3f, mean y = %.3f\n', mean(Pc(:,1)), mean(Pc(:,2)) );
fprintf('max x = %.3f, max y = %.3f\n', max(Pc(:,1)), max(Pc(:,2)) );

bW = poly2mask( Pc(:,1)',Pc(:,2)', M, N );

if view_mask,
	figure;
    subplot( 1,4,1 ); imshow( RGB ); title('color image');
    subplot( 1,4,2 ); imshow( G ); title('gray scale image');
    subplot( 1,4,3 ); imshow( bI ); title('binary image');
	subplot( 1,4,4 ); imshow( bW ); title('binary shape mask');
end;


% ----------------------------------
% Helper function to parse objects
% in binary image.
%
%

function shape = parseContour(c, bI)

k=0; p=1;

while p < size(c,2)
    jc = c(2,p);
    cc = c(:,(p+1):(p+jc));
    p = p+jc+1;
    k = k+1;
    objects{k} = cc;
end;

Ia = size(bI,1)*size(bI,2);
Icm = [ size(bI,1)/2 size(bI,2)/2 ];

Mtx = zeros( length( objects ), 2 );

for i=1:length( objects ),
    
    fprintf('%d of %d objects\n', i, length( objects ) );
    
    obj = objects{i};
    
    shp_stx = shapeArea( obj', bI );
    
    if shp_stx.width >= ( size(bI,1)*.9 ) || shp_stx.height >= ( size(bI,2)*.9 ),
        Mtx(i,1) = 0;
    else,
        Mtx(i,1) = shp_stx.area/Ia;
    end
    
    Mtx(i,2) = pdist( [ shp_stx.ctm ; Icm ], 'euclidean' );
    
%     fprintf('(%d) %.6f %.6f\n', i, Mtx(i,1), Mtx(i,2) );

end;

[VV,~]=sortrows( Mtx, [2] );

[~,idd]=sort( sum( ( Mtx - repmat(VV(1,:),size(Mtx,1),1) ).^2 , 2 ), 'ascend' );

shape = objects{ idd(1)}';

% ----------------------------------
% Helper function size of shape
%
%

function shp_stx = shapeArea( shape, I )

min_vec = min( shape );
max_vec = max( shape );

% -------------------------------------
% simple width x height calucation 
% of rectangular bounding box

B = poly2mask( shape(:,1)',shape(:,2)', size(I,1), size(I,2) );

[Ix,Jx]=ind2sub( size(B), find( B==1 ) );

width = ( max_vec( 1 ) - min_vec( 1 ) );
height = ( max_vec( 2 ) - min_vec( 2 ) );

shp_stx.width = width;
shp_stx.height = height;
shp_stx.area = size( [Ix Jx], 1 );
shp_stx.ctm = mean( [Ix Jx], 1 );


function [xbar,stdev]=threshold( V )
%
%
%
%
%
%
%

N = floor( size( V, 1 )*0.05 );

VV = V( ( end-N:end ), : );

xbar = round( sum( VV(:,1).*VV(:,2) ) / sum( VV(:,1) ) );
stdev = round( sqrt( var( VV(:,2), VV(:,1) ) ) );

fprintf('xbar = %d  stdev = %d\n', xbar, stdev );




