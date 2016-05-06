function procDRImgs()

load( [pwd '/proc/dr/DR.mat'] );

opts.debug = false;
opts.save_masked_rgb = true;

for i=1:length(DR),
    
    img_file = [ DR{i}.path '/' DR{i}.img ];
    
    [bI,bW,T]=shape( img_file );
    
    imwrite( bI, [ DR{i}.path '/mask_bI.jpg'], 'JPEG' );
    
    imwrite( bW, [ DR{i}.path '/mask_bW.jpg'], 'JPEG' );
    
    save( [ DR{i}.path '/Transform.mat'], 'T' );
    
    text( DR{i}, opts );
    
end;