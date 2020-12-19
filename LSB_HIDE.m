function stego_img = HIDE(cover_img,txt_file)
stego_img=cover_img;
stego_img=double(stego_img);
f_id=fopen(txt_file,'r'); 
[msg,len_total]=fread(f_id,'ubit1');
[m,n]=size(stego_img);
if len_total>m*n

    error('overflow');
end
p=1;
for f2=1:n
    for f1=1:m
        stego_img(f1,f2)=stego_img(f1,f2)-mod(stego_img(f1,f2),2)+msg(p,1);
        if p==len_total
            break;
        end
        p=p+1;
    end
    if p==len_total
        break;
    end
end
stego_img=uint8(stego_img);
end

