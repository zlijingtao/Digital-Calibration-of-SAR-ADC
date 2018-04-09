function bina=decimal2binary(deci,length)
bina=zeros(1,length);
if deci>0
    for i=1:100
    bina(i)=rem(deci,2);
    deci=(deci-bina(i))/2;
    if deci<1
        break
    end
    end
    bina=fliplr(bina);
else
    deci_abs=-deci-1;
    for i=1:100
    bina(i)=rem(deci_abs,2);
    deci_abs=(deci_abs-bina(i))/2;
    if deci_abs<1
        break
    end
    end
    bina=fliplr(bina);
    bina=1-bina;
end
end