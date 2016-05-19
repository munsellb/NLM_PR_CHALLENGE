function [bI,bW,T]=shape_con( pill_img )
%
%   Usage: [bI,bW,T]=shape_con( pill_img )
%
%   Description: shape extraction for consumer images.
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

tt = cputime;

RGB = imread( pill_img );
O_RGB = RGB;

if size(RGB,2) ~= 2400,
    M_RGB_SX = M_REF/size(RGB,2);
    RGB = imresize( RGB, M_RGB_SX );
end;

fprintf('RGB Resolution (%d,%d)\n', size(RGB,1), size(RGB,2) );

bW = rmbg( RGB );

c = contourc( double( bW ), 2 );
P = parseContour( c, bW );

P = polyline_points_nd( size(P,2), size(P,1), P, 10 );
P = catmullRom2D( P );

bP = poly2mask( P(:,1)',P(:,2)', size(bW,1), size(bW,2) );

bP( floor(end/2)+1:end, : )  = false;
bP( floor(end/2)+1:end, : ) = bP( floor(end/2):-1:1, : );

bP( :, floor(end/2)+1:end )  = false;
bP( :, floor(end/2)+1:end ) = bP( :, floor(end/2):-1:1 );

c = contourc( double( bP ), 2 );
P = parseContour( c, bP );

P = polyline_points_nd( size(P,2), size(P,1), P, 10 );
P = catmullRom2D( P );
bI = poly2mask( P(:,1)',P(:,2)', size(bW,1), size(bW,2) );

centroid = regionprops( bI,'Centroid' );

x_mean = centroid.Centroid(1);
y_mean = centroid.Centroid(2);

% x_mean = mean( P(:,1) );
% y_mean = mean( P(:,2) );
% 
% [x_mean y_mean ]

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

fprintf('Total time for (%d) = %.4f sec\n', i, (cputime - tt) );

if view_mask,
    
    figure;
    
	Z(:,:,1) = bI;
    Z(:,:,2) = bI;
    Z(:,:,3) = bI;
    
    subplot( 1,3,1 ); imshow( RGB ); title('color image');
    subplot( 1,3,2 ); imshow( RGB.*uint8(Z) ); title('binary image');
	subplot( 1,3,3 ); imshow( bW ); title('binary shape mask');
    
end;


% ----------------------------------
% Helper function to parse objects
% in binary image.
%
%

function shape = parseContour( c, bI )

k=0; p=1;

if isempty( c ),
    
    fprintf('no objects\n');
    [mm,nn]=size( bI );
    r = 100;
    t=-pi:0.001:pi;
    x=r*cos(t) + nn/2;
    y=r*sin(t) + mm/2;
    shape = [ x' y' ];
    
    return;
end;

while p < size(c,2)
    jc = c(2,p);
    cc = c(:,(p+1):(p+jc));
    p = p+jc+1;
    k = k+1;
    objects{k} = cc;
end;

shape = objects{ 1 }';
