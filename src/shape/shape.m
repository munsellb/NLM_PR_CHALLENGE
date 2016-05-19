function [bI,bW,T]=shape( type, pill_img )
%
%   Usage: [bI,bW,T]=shape( type, pill_img )
%
%   Description: shape extraction for pill image
%
%   Return(s): RGB binary mask (bI), square binary mask (bW), and affine
%   transformation (T)
%
%   Arguments: 2 (string)
%              
%              type = DC (consumer) or DR (reference )
%              pill_img = fully qualified path to reference or consumer
%                         color image
%
%   Example usage:
%   
%               [bI,bW,T]=shape( 'DR', '/home/pill/pill_1.jpg' );
%
%
%

error( nargchk(2,2,nargin) );

if ~strcmpi( type, 'DR' ) && ~strcmpi( type, 'DC' ),
    error('type argument not valid, see help');
end;

if strcmpi( type, 'DR' ),
    
    [bI,bW,T] = shape_ref( pill_img );
   
else,
    
    [bI,bW,T] = shape_con( pill_img );
    
end;

