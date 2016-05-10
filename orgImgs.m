function orgImgs( type, data_dir, proc_dir )
%
%   Usage: orgImgs( type, data_dir, proc_dir )
%
%   Description: Organize reference (DC) or consumer (DC) pill images into 
%   directory hierachy. At the completion of the script, the processing directory 
%   will contain a separate directory that has provided the pill image. Additionally, 
%   a Matlab file (DC.mat or DR.mat) will be created that contains a cell, and each 
%   element in the cell defines a structure that has a "path" field and an "img" field. 
%   The path field is the fully qualified location of the pill folder (on the file system), 
%   and the img field has the full name of the image file (including file extension, 
%   such as ".jpg").
%
%   Return: Nothing
%
%   Arguments: 3 required arguments (both strings)
%              
%              type = DR or DC (only these two will be accepted, not case
%              sensitive)
%              data_dir = location of the original pill images.
%              proc_dir = location of processing directory on file system
%              (if the directory does not exist, it will be created).
%
%   Example usage:
%   
%               orgImgs( 'DC', 'data', 'proc' )
%
%
%

error( nargchk(3,3,nargin) );
    
if ~strcmpi( type, 'DR' ) && ~strcmpi( type, 'DC' ),
    error('type argument not valid, see help');
end;

ddir = [ pwd '/' data_dir '/' lower( type ) ];

if ~exist( ddir, 'dir' ),
    error('data directory argument not valid, see help');
end;

D=[];

pdir = [ pwd '/' proc_dir '/' lower( type ) ];

if ~exist( pdir, 'dir' ),
    mkdir( pdir );
end;

imgs = dir( ddir );

cnt = 1;

for i=1:length( imgs ),
    
    [pth,name,ext] = fileparts( imgs(i).name );
    
    if ~isdir( imgs(i).name ) && strcmp( ext, '.jpg' ),
        
        fold_path = [ proc_dir '/' name ];
        
        if ~exist( fold_path, 'dir' ),
            
            mkdir( fold_path );
            
            [success, ~, ~] = copyfile( [ddir '/' name ext], [fold_path '/' name ext] );
            
            if ~success,
                
                fprintf('failed to copy image file [%s : %s]\n', [pth '/' name ext], [fold_path '/' name ext] ); 
  
            else,
                
                D{cnt}.path = fold_path;
                
                D{cnt}.img = [name ext];
                
                fprintf('successfully processed %d %s image\n', cnt, upper( type ) ); 
                
                cnt=cnt+1;
                
            end;
            
        end;
        
    end; 
    
end;

save( [proc_dir '/' upper( type ) '.mat'], 'D' );