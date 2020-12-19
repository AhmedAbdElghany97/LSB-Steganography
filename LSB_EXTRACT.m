function LSB_EXTRACT(img,path,name)
img=double(img);
[m,n]=size(img);
len_total=m*n;
path=strcat(path,name);
msg=fopen(path,'w+');
p=1;
for f2=1:n;
    for f1=1:m;
        if bitand(img(f1,f2),1)==1
            fwrite(msg,1,'ubit1');
            
        else
            fwrite(msg,0,'ubit1');
            
        end
        if p==len_total
            break;
        end
        p=p+1;
    end
    if p==len_total;
        break;
    end
end
fclose(msg);
end

