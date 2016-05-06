function test_text_dr()

load( [pwd '/proc/dr/DR.mat'] );

opts.debug = false;
opts.save_masked_rgb = true;

for i=1:length(DR),
    
    fprintf('processing (%d)\n', i);
    
    text( DR{i}, opts );
    
end;