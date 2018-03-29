function [adco]=SAR_conventional(N)
VREF=1;
len=2^15-8;
LSB=2*VREF/2^N;
LSB=round(LSB*10^N)/10^N;
fs=100;
fin=fs*(0.125*len-17)/len;
Vref=1;
ground=0;
Vcm=1/2;
sig_c=0;
comp_error=0;
C_norp=[];
for r=1:N
    C_norp=[C_norp,2^(N-r)];
end
C_norp=[C_norp,1];
C_norn=C_norp;
C_devp=sig_c*C_norp.*randn(1,N+1);
C_devn=sig_c*C_norn.*randn(1,N+1);
Cp=C_norp+C_devp;
Cn=C_norn+C_devn;
Cp_tot=sum(Cp);
Cn_tot=sum(Cn);
adco=[];
for t=(0:len-1)*(fs/1)
    A=zeros(1,N);
    Vin=VREF*sin(2*pi*fin*t);
    Vinp=Vcm+0.5*Vin;
    Vinn=Vcm-0.5*Vin;
    Ft=zeros(N+1,1);
    Fb=ones(N+1,1);
    Vxp=Vref/2+Vcm-Vinp;
    Vxn=Vref/2+Vcm-Vinn;
    if err_compare(Vxn,Vxp,comp_error)==1
        A(1)=1;
        Ft(1)=1;
        Fb(1)=0;
    else
        A(1)=0;
        Ft(1)=0;
        Fb(1)=1;
    end
    for i=1:N-1
        Ft(i+1)=1;
        Fb(i+1)=0;
        Vxp=(Cp*Ft*Vref+Vcm*Cp_tot-Vinp*Cp_tot)/Cp_tot;
        Vxn=(Cn*Fb*Vref+Vcm*Cn_tot-Vinn*Cn_tot)/Cn_tot;
        if err_compare(Vxn,Vxp,comp_error)==1
            A(i+1)=1;
        else
            if i==N-1
                A(i+1)=0;
            else
                A(i+1)=0;
                Ft(i+1)=0;
                Fb(i+1)=1;
            end
        end
    end
    adco=[adco;A];
end
                


        
        
        
        
        
        
        
        
        
        
        