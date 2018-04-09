function MSB3=Flash_JSSC_shen(Vin,Vref)
Vina=Vin+Vref;
for i=1:7
V_floor(i)=(2*Vref/8)*i;
compare_result(i)=err_compare(Vina,V_floor(i),0);
end

switch sum(compare_result)
    case 0
        MSB3=[0 0 0];
    case 1
        MSB3=[0 0 1];
    case 2
        MSB3=[0 1 0];
    case 3
        MSB3=[0 1 1];
    case 4
        MSB3=[1 0 0];
    case 5
        MSB3=[1 0 1];
    case 6
        MSB3=[1 1 0];
    case 7
        MSB3=[1 1 1];
end
