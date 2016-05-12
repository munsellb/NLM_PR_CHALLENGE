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
%           d = jaccardCoeff( im2bw( imread( 'A.jpg' ) ), im2bw( imread(
%           'B.jpg' ) ), 30 );
%
%
%

step = 90;

error( nargchk(2,2,nargin) );

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





