function DR=orgDRImgs()

DR=[];

dr_dir = [ pwd '/data/dr' ];

proc_dir = [ pwd '/proc/dr'];

if ~exist( proc_dir, 'dir' ),
    mkdir( proc_dir );
end;

ref_imgs = dir( dr_dir );

cnt = 1;

for i=1:length( ref_imgs ),
    
    [pth,name,ext] = fileparts( ref_imgs(i).name );
    
    if ~isdir( ref_imgs(i).name ) && strcmp( ext, '.jpg' ),
        
        fold_path = [ proc_dir '/' name ];
        
        if ~exist( fold_path, 'dir' ),
            
            mkdir( fold_path );
            
            [success, ~, ~] = copyfile( [dr_dir '/' name ext], [fold_path '/' name ext] );
            
            if ~success,
                
                fprintf('failed to copy image file [%s : %s]\n', [pth '/' name ext], [fold_path '/' name ext] ); 
  
            else,
                
                DR{cnt}.path = fold_path;
                
                DR{cnt}.img = [name ext];
                
                cnt=cnt+1;
                
                fprintf('successfully processed %d DR image\n', cnt ); 
                
            end;
            
        end;
        
    end; 
    
end;

save( [proc_dir '/DR.mat'],'DR' );