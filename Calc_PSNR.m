function psnr = Calc_PSNR(img1,img2)
    [row,col] = size(img1);
    size_host = row*col;
    o_double = double(img1);
    w_double = double(img2);
    s=0;
for j = 1:size_host;
    s = s+(w_double(j) - o_double(j))^2 ; 
end
mes=s/size_host;
psnr =10*log10((255)^2/mes);
end
