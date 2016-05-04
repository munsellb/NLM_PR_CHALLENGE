function [bI,bW,T]=shape( pill_img )
%
%
%
%
%
%
%

M = 500;
N = 500;
F = floor( M/2 );
S = floor( M/5 );

view_shape = false;
view_mask = false;

I = imread( pill_img );

bI = rgb2gray( I );

[cnt, bin] = imhist( bI );

V = sortrows( [cnt bin], 1 );
V = V(end,:);

idx_black = find( bI == V(2) );
idx_white = find( bI ~= V(2) );

bI(idx_black) = 0;
bI(idx_white) = 255;

c = contourc( double( bI ), 2 );

P = parseContour( c, bI );

if view_shape,
	figure;
	plot( P(:,1),P(:,2)); axis equal; axis off;
end;

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
    subplot( 1,3,1 ); imshow( I ); title('color image');
    subplot( 1,3,2 ); imshow( bI ); title('binary image');
	subplot( 1,3,3 ); imshow( bW ); title('binary shape mask');
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
    
    obj = objects{i};
    
    [area,ctm] = shapeArea( obj' );
    
    Mtx(i,1) = area/Ia;
    Mtx(i,2) = pdist( [ ctm ; Icm ], 'euclidean' );
    
    %fprintf('(%d) %.6f %.6f\n', i, Mtx(i,1), Mtx(i,2) );

end;

[~,idd]=sortrows( Mtx, [-1 2] );

% fprintf( '%.7f\n', Mtx(idd(1),1) );

shape = objects{idd(1)}';

% ----------------------------------
% Helper function size of shape
%
%

function [area,cm] = shapeArea( shape )

min_vec = min( shape );
max_vec = max( shape );

% -------------------------------------
% simple width x height calucation 
% of rectangular bounding box

width = ( max_vec( 1 ) - min_vec( 1 ) );
height = ( max_vec( 2 ) - min_vec( 2 ) );

area = width * height;

cm = mean( shape );




