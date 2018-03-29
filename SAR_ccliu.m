function [adco,Energy_mean]=SAR_ccliu(N)
%Input is the bits of the ADC, N must be a even number and usually larger than 4.
VREF=1;
len=2^15-8; % the Scale of the output matrix (adco) is thus len*N.
LSB=2*VREF/2^N; %Define LSB as the resolution.
LSB=round(LSB*10^N)/10^N;
fs=100;  % frequency of sampling clock, in Mhz   
fin=fs*(0.125*len-17)/len;
Vref=1;%We define the Vref=1V, our bianry search range is thus -1v~+1V
ground=0;
Vcm=1/2;%The common mode voltage is defined as half of the Vref
sig_c=0;%Define the Standard Deviation (Std) of an unit capacitor
comp_error=0;%Define the posibility of an error decision in the SAR process
C_norp=[];
for r=1:N-1;
    C_norp=[C_norp, 2^(N-1-r)];
end
C_norp=[C_norp, 1];
C_norn=C_norp;
C_devp=sig_c*C_norp.*randn(1,N);%The deviation of Capacitor in this work
C_devn=sig_c*C_norn.*randn(1,N);
Cp=C_norp+C_devp;%Real value of the DAC is the sum of the Ideal value and the deviation
Cn=C_norn+C_devn;
Cp_tot=sum(Cp);%Total Capacitance of the Capacitive Array
Cn_tot=sum(Cn);
adco=[];
E=[];
for t=(0:len-1)*(1/fs)
A=zeros(1,N);
Vin=VREF*sin(2*pi*fin*t); % Our input is an sinusoidal wave
Vinp=Vcm+0.5*Vin;
Vinn=Vcm-0.5*Vin;
Ft=ones(N,1);%Define the Switch on the top side array, equals to 1 means they connect to Vref
Fb=ones(N,1);
Vxp=Vinp;%The bootstrap characteristics proposed in Liu et al.'s work
Vxn=Vinn;
Energy=0;%Energy consumption
old_Ft=Ft;
old_Fb=Fb;
if err_compare(Vxp,Vxn,comp_error)==1
    A(1)=1;%MSB output
    Ft(1)=0;
else
    A(1)=0;
    Fb(1)=0;
end
new_Vxp=(Cp*Ft*Vref-Cp_tot*Vref+Cp_tot*Vinp)/Cp_tot;
new_Vxn=(Cn*Fb*Vref-Cn_tot*Vref+Cn_tot*Vinn)/Cn_tot;
Energy=Energy + Cp*(abs((new_Vxp*ones(N,1)-Ft*Vref)-(Vxp*ones(N,1)-old_Ft*Vref)).^2) + Cn*(abs((new_Vxn*ones(N,1)-Fb*Vref)-(Vxn*ones(N,1)-old_Fb*Vref)).^2);
%Delta_Energy= capacitance* (Voltage_new-Voltage_old)^2
for i=1:N-1
    Vxp=(Cp*Ft*Vref-Cp_tot*Vref+Cp_tot*Vinp)/Cp_tot;
    Vxn=(Cn*Fb*Vref-Cn_tot*Vref+Cn_tot*Vinn)/Cn_tot;
    old_Ft=Ft;
    old_Fb=Fb;
    if err_compare(Vxp,Vxn,comp_error)==1
        if i==N-1
            A(i+1)=1;
        else
            A(i+1)=1;
            Ft(i+1)=0;
        end
    else
         if i==N-1
            A(i+1)=0;
        else
            A(i+1)=0;
            Fb(i+1)=0;
        end
    end
    new_Vxp=(Cp*Ft*Vref-Cp_tot*Vref+Cp_tot*Vinp)/Cp_tot;
    new_Vxn=(Cn*Fb*Vref-Cn_tot*Vref+Cn_tot*Vinn)/Cn_tot;
    if i<N-1
    Energy=Energy + Cp*(abs((new_Vxp*ones(N,1)-Ft*Vref)-(Vxp*ones(N,1)-old_Ft*Vref)).^2) + Cn*(abs((new_Vxn*ones(N,1)-Fb*Vref)-(Vxn*ones(N,1)-old_Fb*Vref)).^2);
    end
end
E=[E;Energy];
adco=[adco;A];
end
Energy_mean=sum(E)/length(E);
