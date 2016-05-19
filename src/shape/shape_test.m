function shape_test()

num_test_images = 6;

% I=[0:200:4000];
% i=I(15);

% I=[0:1:20];
% i=I(19);

for i=1151:100:1961, %200:4000, %num_test_images,
    
    test_img = ['proc/dc/' num2str(i) '/' num2str(i) '.jpg' ];
    
    shape( 'DC', test_img );
    
end;