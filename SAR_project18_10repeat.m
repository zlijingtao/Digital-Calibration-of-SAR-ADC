function [adco,Energy_mean]=SAR_project18_10repeat
%Input is the bits of the ADC, N must be a even number and usually larger than 4.
Vref=1;%We define the V-suply=1V, our bianry search range is thus -1v~+1V
N=18;
len=2^15-8; % the Scale of the output matrix (adco) is thus len*N.
LSB=2*Vref/2^N; %Define LSB as the resolution.
LSB=round(LSB*10^N)/10^N;
fs=100;  % frequency of sampling clock, in Mhz   
fin=fs*(0.125*len-17)/len;
ground=0;
Vcm=1/2*Vref;%The common mode voltage is defined as half of the Vref
sig_c=0;%Define the Standard Deviation (Std) of an unit capacitor
comp_error=0;%Define the posibility of an error decision in the SAR process
C_norp3=[16 16 8 4 2 1 1 1 1 1 1 1 1 1 1 1 1];%C_norp3(2)-Redun3; C_norp3(6:15)-10LSBs
C_norp2=[16 16 8 4 2 1];%C_norp2(2)-Redun2
C_norp1=[128, 64, 32, 16, 8, 8, 4, 2, 1];%C_norp1(5)-Redun1
C_devp3=sig_c*C_norp3.*randn(1,17);%+10
C_devp2=sig_c*C_norp2.*randn(1,6);
C_devp1=sig_c*C_norp1.*randn(1,9);
C_brip3_2=(sum(C_norp3)/(32-1))*(1+randn(1,1)*sig_c);%The bridge cap between array 3 and array 2
C_brip2_1=((sum(C_norp2)+(sum(C_norp3)/32))/(32-1))*(1+randn(1,1)*sig_c)%The bridge cap between array 2 and array 1
C_p3=C_norp3+C_devp3;
C_p2=C_norp2+C_devp2;
C_p1=C_norp1+C_devp1;
C_p3tot=sum(C_p3);
C_p2tot=sum(C_p2);
C_p1tot=sum(C_p1);
outerfactor_p3_2=(C_p3tot*C_brip3_2)/(C_p3tot+C_brip3_2);
outerfactor_p2_1=((C_p2tot+outerfactor_p3_2)*C_brip2_1)/(C_p2tot+outerfactor_p3_2+C_brip2_1);
Cp=[C_p1,C_p2/(C_p2tot+outerfactor_p3_2)*outerfactor_p2_1,C_p3/C_p3tot*outerfactor_p3_2/(C_p2tot+outerfactor_p3_2)*outerfactor_p2_1]
LenC=length(Cp);
%you can check the weight by delete the ";".
C_brin3_2=(sum(C_norp3)/(32-1))*(1+randn(1,1)*sig_c);%The bridge cap between array 3 and array 2
C_brin2_1=((sum(C_norp2)+(sum(C_norp3)/32))/(32-1))*(1+randn(1,1)*sig_c);%The bridge cap between array 2 and array 1
C_n3=C_p3;
C_n2=C_p2;
C_n1=C_p1;
C_n3tot=sum(C_n3);
C_n2tot=sum(C_n2);
C_n1tot=sum(C_n1);
outerfactor_n3_2=(C_n3tot*C_brin3_2)/(C_n3tot+C_brin3_2);
outerfactor_n2_1=((C_n2tot+outerfactor_n3_2)*C_brin2_1)/(C_n2tot+outerfactor_n3_2+C_brin2_1);
Cn=[C_n1,C_n2/(C_n2tot+outerfactor_n3_2)*outerfactor_n2_1,C_n3/C_n3tot*outerfactor_n3_2/(C_n2tot+outerfactor_n3_2)*outerfactor_n2_1];
Cp_tot=sum(Cp);%Total Capacitance of the Capacitive Array
Cn_tot=sum(Cn);
factor=(Cp_tot+Cn_tot-Cp(6)-Cp(11)-Cp(17)-sum(Cp(22:31))-Cn(6)-Cn(11)-Cn(17)-sum(Cn(22:31)))/(Cp_tot+Cn_tot);
adco=[];
E=[];
for t=(0:len-1)*(1/fs)
A=zeros(1,LenC-1);
Vin=Vref*factor*sin(2*pi*fin*t); % Our input is an sinusoidal wave
MSB3=Flash_JSSC_shen(Vin,Vref);
Vinp=Vcm+0.5*Vin;
Vinn=Vcm-0.5*Vin;
Ft=zeros(LenC,1);%Define the Switch on the top side array, equals to 0 means they connect to GND, and 1 means they connect to Vref
Fb=zeros(LenC,1);
A(1:3)=MSB3;
Ft(1:3)=MSB3;
Ft(4)=1;% first step, connect C_1t to Vref, others to GND
Fb=1-Ft;%complementary characteristic
Vxp=Vcm-Vinp+Cp*Ft*Vref/Cp_tot;%The bootstrap characteristics proposed in Liu et al.'s work
Vxn=Vcm-Vinn+Cn*Fb*Vref/Cn_tot;
Energy=Cp*(abs(Vxp*ones(LenC,1)-Ft*Vref-(Vcm-Vinp)*ones(LenC,1)).^2)+Cn*(abs(Vxn*ones(LenC,1)-Fb*Vref-(Vcm-Vinn)*ones(LenC,1)).^2);%Energy consumption
old_Ft=Ft;
old_Fb=Fb;
if err_compare(Vxp,Vxn,comp_error)==1
    A(4)=0;%MSB output
    Ft(4)=0;
    Ft(5)=1;
    Fb=1-Ft;
else
    A(4)=1;
    Ft(5)=1;
    Fb=1-Ft;
end
new_Vxp=Vcm-Vinp+Cp*Ft*Vref/Cp_tot;
new_Vxn=Vcm-Vinn+Cn*Fb*Vref/Cn_tot;
Energy=Energy + Cp*(abs((new_Vxp*ones(LenC,1)-Ft*Vref)-(Vxp*ones(LenC,1)-old_Ft*Vref)).^2) + Cn*(abs((new_Vxn*ones(LenC,1)-Fb*Vref)-(Vxn*ones(LenC,1)-old_Fb*Vref)).^2);
%Delta_Energy= capacitance* (Voltage_new-Voltage_old)^2
format long
for i=4:LenC-2
    Vxp=Vcm-Vinp+Cp*Ft*Vref/Cp_tot;
    Vxn=Vcm-Vinn+Cn*Fb*Vref/Cn_tot;
    old_Ft=Ft;
    old_Fb=Fb;
    if err_compare(Vxp,Vxn,comp_error)==1
        A(i+1)=0;
        if i>=20
            Ft(i+1)=0;
            Ft(i+2)=0;
            Fb=1-Ft;
            if xor(A(i+1),A(i))==1
            for u=i+1:LenC-2
            A(u+1)=1-A(u);
            end
            break
            end
        else
            Ft(i+1)=0;
            Ft(i+2)=1;
            Fb=1-Ft;
        end
    else
        A(i+1)=1;
        if i>=20
            Ft(i+1)=1;
            Ft(i+2)=1;
            Fb=1-Ft;
            if xor(A(i+1),A(i))==1
            for u=i+1:LenC-2
            A(u+1)=1-A(u);
            end
            break
            end           
        else
            Ft(i+2)=1;
            Fb=1-Ft;
        end
    end
    new_Vxp=Vcm-Vinp+Cp*Ft*Vref/Cp_tot;
    new_Vxn=Vcm-Vinn+Cn*Fb*Vref/Cn_tot;
    if i<LenC-2
    Energy=Energy + Cp*(abs((new_Vxp*ones(LenC,1)-Ft*Vref)-(Vxp*ones(LenC,1)-old_Ft*Vref)).^2) + Cn*(abs((new_Vxn*ones(LenC,1)-Fb*Vref)-(Vxn*ones(LenC,1)-old_Fb*Vref)).^2);
    end
end
E=[E;Energy];
F=decimal2binary(-4096-256-8-5,19);
%The calibration number is -2048-128-8
B=zeros(1,18);
C=zeros(1,18);
%First row plus the third row -4096-256-8 (F1~F19)
% + Compensation Capacotor A(6) A(11) A(17) A(22:31)->G
G=decimal2binary(sum(A(22:31)),4);
[B(18),C(18)]=full_adder(F(19),G(4),0);
[B(17),C(17)]=full_adder(F(18),G(3),C(18));
[B(16),C(16)]=full_adder(F(17),G(2),C(17));
[B(15),C(15)]=full_adder(F(16),G(1),C(16));
[B(14),C(14)]=full_adder(F(15),A(17),C(15));
[B(13),C(13)]=full_adder(F(14),0,C(14));
[B(12),C(12)]=full_adder(F(13),0,C(13));
[B(11),C(11)]=full_adder(F(12),0,C(12));
[B(10),C(10)]=full_adder(F(11),0,C(11));
[B(9),C(9)]=full_adder(F(10),A(11),C(10));
[B(8),C(8)]=full_adder(F(9),0,C(9));
[B(7),C(7)]=full_adder(F(8),0,C(8));
[B(6),C(6)]=full_adder(F(7),0,C(7));
[B(5),C(5)]=full_adder(F(6),A(6),C(6));
[B(4),C(4)]=full_adder(F(5),0,C(5));
[B(3),C(3)]=full_adder(F(4),0,C(4));
[B(2),C(2)]=full_adder(F(3),0,C(3));
[B(1),C(1)]=full_adder(F(2),0,C(2));
Bsign=full_adder(F(1),0,C(1));
%Then plus the Normal capacitor
D=zeros(1,18);
C=zeros(1,18);
[D(18),C(18)]=full_adder(B(18),A(21),0);
[D(17),C(17)]=full_adder(B(17),A(20),C(18));
[D(16),C(16)]=full_adder(B(16),A(19),C(17));
[D(15),C(15)]=full_adder(B(15),A(18),C(16));
[D(14),C(14)]=full_adder(B(14),A(16),C(15));
[D(13),C(13)]=full_adder(B(13),A(15),C(14));
[D(12),C(12)]=full_adder(B(12),A(14),C(13));
[D(11),C(11)]=full_adder(B(11),A(13),C(12));
[D(10),C(10)]=full_adder(B(10),A(12),C(11));
[D(9),C(9)]=full_adder(B(9),A(10),C(10));
[D(8),C(8)]=full_adder(B(8),A(9),C(9));
[D(7),C(7)]=full_adder(B(7),A(8),C(8));
[D(6),C(6)]=full_adder(B(6),A(7),C(7));
[D(5),C(5)]=full_adder(B(5),A(5),C(6));
[D(4),C(4)]=full_adder(B(4),A(4),C(5));
[D(3),C(3)]=full_adder(B(3),A(3),C(4));
[D(2),C(2)]=full_adder(B(2),A(2),C(3));
[D(1),C(1)]=full_adder(B(1),A(1),C(2));

overflow=xor(C(1),Bsign);
if overflow==1
    if D(1)==1
        D=zeros(1,18);
    else
        D=ones(1,18);
    end
end

adco=[adco;D];
end
Energy_mean=sum(E)/length(E);