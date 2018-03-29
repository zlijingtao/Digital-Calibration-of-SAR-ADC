function [adco,Energy_mean]=SAR_ccliu_10b_rd
%This is an SAR ADC architecture with proposed monolithic switching procedure, and redundant design to tolerate the decision error.
VREF=1;
N=10;%It's a 10-bit SAR ADC
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
%C_norp=[256, 128, 128, 64, 32, 16, 16, 8, 4, 2, 2, 1, 1];
C_norp=[ 256, 128, 64, 64, 32, 16, 8, 8, 4, 2, 1, 1, 1];
C_norn=C_norp;
C_devp=sig_c*C_norp.*randn(1,N+3);%The deviation of Capacitor in this work
C_devn=sig_c*C_norn.*randn(1,N+3);
Cp=C_norp+C_devp;%Real value of the DAC is the sum of the Ideal value and the deviation
Cn=C_norn+C_devn;
Cp_tot=sum(Cp);%Total Capacitance of the Capacitive Array
Cn_tot=sum(Cn);
factor=(sum(Cp)+sum(Cn)-Cp(4)-Cp(8)-Cp(12)-Cn(4)-Cn(8)-Cn(12))/(sum(Cp)+sum(Cn));
adco=[];
E=[];
for t=(0:len-1)*(1/fs)
A=zeros(1,N+3);
Vin=VREF*factor*sin(2*pi*fin*t); % Our input is an sinusoidal wave
Vinp=Vcm+0.5*Vin;
Vinn=Vcm-0.5*Vin;
Ft=ones(N+3,1);%Define the Switch on the top side array, equals to 1 means they connect to Vref
Fb=ones(N+3,1);
Vxp=Vinp;%The bootstrap characteristics proposed in Liu et al.'s work
Vxn=Vinn;
Energy=0;%Energy consumption
old_Ft=Ft;
old_Fb=Fb;
if Vxp>Vxn
    A(1)=1;%MSB output
    Ft(1)=0;
else
    A(1)=0;
    Fb(1)=0;
end
new_Vxp=(Cp*Ft*Vref-Cp_tot*Vref+Cp_tot*Vinp)/Cp_tot;
new_Vxn=(Cn*Fb*Vref-Cn_tot*Vref+Cn_tot*Vinn)/Cn_tot;
Energy=Energy + Cp*(abs((new_Vxp*ones(N+3,1)-Ft*Vref)-(Vxp*ones(N+3,1)-old_Ft*Vref)).^2) + Cn*(abs((new_Vxn*ones(N+3,1)-Fb*Vref)-(Vxn*ones(N+3,1)-old_Fb*Vref)).^2);
%Delta_Energy= capacitance* (Voltage_new-Voltage_old)^2
for i=1:N+2
    Vxp=(Cp*Ft*Vref-Cp_tot*Vref+Cp_tot*Vinp)/Cp_tot;
    Vxn=(Cn*Fb*Vref-Cn_tot*Vref+Cn_tot*Vinn)/Cn_tot;
    old_Ft=Ft;
    old_Fb=Fb;
    if err_compare(Vxp,Vxn,comp_error)==1
        if i==N+2
            A(i+1)=1;
        else
            A(i+1)=1;
            Ft(i+1)=0;
        end
    else
         if i==N+2
            A(i+1)=0;
        else
            A(i+1)=0;
            Fb(i+1)=0;
        end
    end
    new_Vxp=(Cp*Ft*Vref-Cp_tot*Vref+Cp_tot*Vinp)/Cp_tot;
    new_Vxn=(Cn*Fb*Vref-Cn_tot*Vref+Cn_tot*Vinn)/Cn_tot;
    if i<N+2
    Energy=Energy + Cp*(abs((new_Vxp*ones(N+3,1)-Ft*Vref)-(Vxp*ones(N+3,1)-old_Ft*Vref)).^2) + Cn*(abs((new_Vxn*ones(N+3,1)-Fb*Vref)-(Vxn*ones(N+3,1)-old_Fb*Vref)).^2);
    end
end
E=[E;Energy];

%This part is for converting the 13-b after compensation to the normal 10-b
%A(1-3)=B1-B3 A(4)-B3c A(5-7)=B4-B6 A(8)-B6c A(9-11)=B7-B9 A(12)-B9c
%A(13)-B(10)
B=zeros(1,N);
C=zeros(1,N);
B(10)=1-A(13);
C(10)=0;
[B(9),C(9)]=full_adder((1-A(12)),A(11),C(10));
[B(8),C(8)]=full_adder((1-A(12)),A(10),C(9));
[B(7),C(7)]=full_adder(A(12),A(9),C(8));
[B(6),C(6)]=full_adder((1-A(8)),A(7),C(7));
[B(5),C(5)]=full_adder((1-A(8)),A(6),C(6));
[B(4),C(4)]=full_adder(A(8),A(5),C(5));
[B(3),C(3)]=full_adder((1-A(4)),A(3),C(4));
[B(2),C(2)]=full_adder((1-A(4)),A(2),C(3));
[B(1),C(1)]=full_adder((1-A(4)),A(1),C(2));

overflow=xor(C(1),(1-A(4)));
if overflow==1
    if B(1)==1
        B=zeros(1,N);
    else
        B=ones(1,N);
    end
end

adco=[adco;B];
end
Energy_mean=sum(E)/length(E);