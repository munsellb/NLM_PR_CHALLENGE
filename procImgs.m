function procImgs( type, proc_dir )
%
%   Usage: procImgs( type, proc_dir )
%
%   Description: Process reference (DC) or consumer (DC) pill images using 
%   directory hierachy created in orgImgs script. At the completion of the 
%	script, the files required to compute our three features (shape, text, 
%	will be created in the directory for each pill reference or consumer pill.
%
%   Return: Nothing
%
%   Arguments: 2 required arguments (both strings)
%              
%              type = DR or DC (only these two will be accepted, not case
%              sensitive)
%              proc_dir = location of processing directory on file system.
%
%   Example usage:
%   
%               procImgs( 'DC', 'proc' )
%
%	Note: The following files are created
%		1) mask_bI.jpg (binary mask that has the same resolution as RGB pill image)
%		2) mask_bW.jpg (square binary mask used to compute shape feature)
%		3) mask_RGB.jpg (square color mask used to compute text feature)
%		4) lcolor.png (square color image used to compute color feature)
%
%	
%

error( nargchk(2,2,nargin) );
    
if ~strcmpi( type, 'DR' ) && ~strcmpi( type, 'DC' ),
    error('type argument not valid, see help');
end;

pdir = [ pwd '/' proc_dir '/' lower( type ) ];

if ~exist( pdir, 'dir' ),
    error('data directory argument not valid, see help');
end;

D=[];

load( [ pwd '/' proc_dir '/' upper(type) '.mat'] );

opts.debug = false;
opts.save_masked_rgb = true;

for i=1:length(D),
    
    img_file = [ D{i}.path '/' D{i}.img ];
    
    [bI,bW,T]=shape( img_file );
    
    imwrite( bI, [ D{i}.path '/mask_bI.jpg'], 'JPEG' );
    
    imwrite( bW, [ D{i}.path '/mask_bW.jpg'], 'JPEG' );
    
    save( [ D{i}.path '/Transform.mat'], 'T' );
    
    text( D{i}, opts );
    
end;