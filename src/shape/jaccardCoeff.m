function [ d, angle ] = jaccardCoeff( A, B )
%
%   Usage: [ d, angle ] = jaccardCoeff( A, B )
%
%   Description: Compute the Jaccard coefficent between two binary
%                images that have the same size/resolution.
%
%
%   Arguments:
%           A = binary image (ones and zeros)
%           B = binary image (ones and zeros)
%
%   Return:
%           d = jaccard coefficent ( A and B ) / ( A or B )
%           angle = img B rotated (in degrees) to achieve best jaccard coef. 
%   
%
%   Example:
%
%           bA = im2bw( imread( 'A.jpg' );
%           bB = im2bw( imread( 'B.jpg' );
%           [ d, ang ] = jaccardCoeff( bA, bB );
%
%
%

show_cputime = false;

step = 180;

error( nargchk( 2, 2, nargin ) );

if show_cputime, tt = cputime; end;

Ia = im2bw( imread( [ A.path '/mask_bW.jpg' ] ) );
Ib = im2bw( imread( [ B.path '/mask_bW.jpg' ] ) );

d = 0;
angle = 0;

for i=0:step:180,
    
    Ib = imrotate( Ib, i, 'crop' );
    
    dd = sum( sum( ( Ia & Ib ) ) ) / sum( sum( ( Ia | Ib ) ) );
    
    if dd > d,
        
        d = dd;
        angle = i;
        
    end;
    
end;

if show_cputime, fprintf('(jaccard) total time = %.4f sec\n', cputime-tt ); end;



