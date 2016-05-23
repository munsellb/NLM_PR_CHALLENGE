function showmethepills()

setmenv();

orgImgs('DR','data','proc');
orgImgs('DC','data','proc');

procImgs('DR','proc');
procImgs('DC','proc');

opts.range = [1 5000];
opts.save_files = true;
opts.href = 1;

classify( 'proc', 'DR', 'DC', opts );

generateMR( 'proc', 'ShowMeThePills' );