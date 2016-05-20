function X = nudge( I, N )
%
%   Usage: X = nudge( I, N )
%
%   Description: Nudge the image to the  
%   right, left, top, and bottom N pixels
%
%   Arguments:
%       I = RGB or Grayscale Image
%       N = number of pixels to nudge
%
%   Return:
%       X = 4 element cell, each element is 
%           a structure that has three fields:
%           1) tform = affine transformation (pure translation)
%           2) I = transformed image
%           3) dir = direction (top, bottom, left, right)
%       
%   Example:
%           I = imread( 'test.jpg' );
%           X = nudge( I )
%       
%

I = imresize( I, 0.25 );

debug = false;

show_cputime = false;

error( nargchk( 2, 2, nargin ) );

if show_cputime, tt = cputime; end;

N = double( abs( N ) );

X = cell(1,5);

A = [ 1 0 0; 0 1 0; 0 0 1];
Ar = [ 1 0 0; 0 1 0; N 0 1];
Al = [ 1 0 0; 0 1 0; -N 0 1];
At = [ 1 0 0; 0 1 0; 0 -N 1];
Ab = [ 1 0 0; 0 1 0; 0 N 1];

X{1}.tform = maketform('affine', A );
X{1}.dir = 'none';

X{2}.tform = maketform('affine', Ar );
X{2}.dir = 'right';

X{3}.tform = maketform('affine', Al );
X{3}.dir = 'left';

X{4}.tform = maketform('affine', At );
X{4}.dir = 'top';

X{5}.tform = maketform('affine', Ab );
X{5}.dir = 'bottom';

X{1}.I = I;
X{2}.I = imtransform( I, X{2}.tform, 'XData',[1 size(I,2)], 'YData',[1 size(I,1)] );
X{3}.I = imtransform( I, X{3}.tform, 'XData',[1 size(I,2)], 'YData',[1 size(I,1)] );
X{4}.I = imtransform( I, X{4}.tform, 'XData',[1 size(I,2)], 'YData',[1 size(I,1)] );
X{5}.I = imtransform( I, X{5}.tform, 'XData',[1 size(I,2)], 'YData',[1 size(I,1)] );

if show_cputime, fprintf('(nudge) total time = %.3f sec\n', cputime-tt ); end;

% figure; imshow( X{3}.I );

if debug,
    
    figure;
    
    for i=1:5,
        
        s_tit = [ 'Nudge to ' X{i}.dir ];
        
        subplot(1,5,i); imshow( X{i}.I ); title( s_tit );
    
    end;
end;
