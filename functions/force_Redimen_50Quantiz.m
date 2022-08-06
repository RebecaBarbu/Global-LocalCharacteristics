function [fN1, fN2] = force_Redimen_50Quantiz(Q_forced,dim_imag_forced, fileName1, fileName2)


img = imresize(imread(fileName1), [dim_imag_forced dim_imag_forced]);
imwrite(img, 'temp1.jpg','jpg','quality', Q_forced);
img = imresize(imread(fileName2), [dim_imag_forced dim_imag_forced]);
imwrite(img, 'temp2.jpg', 'jpg','quality', Q_forced);

fN1 = 'temp1.jpg';
fN2 = 'temp2.jpg';
end