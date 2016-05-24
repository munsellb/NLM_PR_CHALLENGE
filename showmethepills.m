function showmethepills( ref_dir, con_dir )
%
%	Usage: showmethepills( ref_dir, con_dir)
%
%
%
%
%
%

if nargin ~= 2,
    
    fprintf('Application requires two input arguments\n\n');
    fprintf('Usage: showmethepills( ref_dir, con_dir)\n')
    fprintf('       ref_dir = path to reference image folder\n');
    fprintf('       con_dir = path to consumer image folder\n');
    fprintf('Note: both arguments are strings\n\n');
    
    return;
    
end;

fprintf('-----------------------------------------------\n');
fprintf('[Step 1]: Executing Application\n');

fprintf('[Step 2]: Organizing the reference pill images\n');
orgImgs( 'DR', ref_dir, 'proc' );

fprintf('[Step 2]: Organizing the consumer pill images\n');
orgImgs( 'DC', con_dir, 'proc' );

fprintf('[Step 3]: Processing the reference pill images\n');
procImgs('DR','proc');

fprintf('[Step 3]: Processing the consumer pill images\n');
procImgs('DC','proc');

opts.range = [1 5000];
opts.save_files = true;
opts.href = 1;

fprintf('[Step 4]: Performing pill classification\n');
classify( 'proc', 'DR', 'DC', opts );

fprintf('[Step 5]: Creating MR CSV file\n');
generateMR( 'proc', 'ShowMeThePills' );