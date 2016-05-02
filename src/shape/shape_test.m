function runAllTests()

num_test_images = 6;

for i=1:num_test_images,
    
    test_img = ['test' num2str(i) '.jpg' ];
    
    lucasTest( test_img );
    
end;