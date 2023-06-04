function [img] = j750Dither2D(img,noise)
    CMYKW =[0 1 1; 1 0 1; 1 1 0; 0.01 0.01 0.01; 1 1 1;];
    img = imnoise(img,'gaussian',0,noise);
    img = dither(img,CMYKW);
    img = ind2rgb(img,CMYKW);
end