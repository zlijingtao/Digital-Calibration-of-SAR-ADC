function [adco,Energy_mean]=SAR_ccliu(N)
VREF=1;
len=2^15-8;
%N=14;%定义N-bit精度或作为函数输入
LSB=2*VREF/2^N;
LSB=round(LSB*10^N)/10^N;
fs=100;  % frequency of sampling clock, in Mhz   
fin=fs*(0.125*len-17)/len;
Vref=1;%设定vref=2v,在此为正向1v，满足二分查找在-1-1v内
ground=0;
Vcm=1;%共模电压输入为电源电压的一半
sig_c=0.002;%定义单位电容的标准偏差为了使由电容失配带来的误差不超过LSB/2，σc/C需满足：σc/C<1/2^(N+1)/2；——14位精度的需满足标准偏差< 1/181.02
C_norp=[];
for r=1:N-1;
    C_norp=[C_norp, 2^(N-1-r)];
end
C_norp=[C_norp, 1];
C_norn=C_norp;
C_devp=sig_c*C_norp.*randn(1,N);%电容阵列中各电容的标准偏差
C_devn=sig_c*C_norn.*randn(1,N);%电容阵列中各电容的标准偏差
Cp=C_norp+C_devp;%定义实际电容由其均值和标准偏差组成
Cn=C_norn+C_devn;%定义实际电容由其均值和标准偏差组成
Cp_tot=sum(Cp);%电容阵列的总电容
Cn_tot=sum(Cn);%电容阵列的总电容
adco=[];
E=[];
for t=(0:len-1)*(1/fs)
A=zeros(1,N);
Vin=VREF*sin(2*pi*fin*t);
Vinp=Vcm+0.5*Vin;
Vinn=Vcm-0.5*Vin;
Qp=Cp_tot*(Vref-Vinp);%电路初始状态，电荷守恒方程左边
Qn=Cn_tot*(Vref-Vinn);
Ft=ones(N,1);%定义顶部反馈控制电容开关的矩阵,初始顶部极板全接Vref
Fb=ones(N,1);%定义底部反馈控制电容开关的矩阵,初始顶部极板全接Vref
Vxp=Vinp;%断开开关,不需要动任何电容，即可比较MSB，原理在于此时Vxp=Vinp
Vxn=Vinn;
Energy=0;%第一次的能量消耗为零
old_Ft=Ft;
old_Fb=Fb;
if Vxp >= Vxn
    A(1)=1;
    Ft(1)=0;
else
    A(1)=0;
    Fb(1)=0;
end
new_Vxp=(Cp*Ft*Vref-Cp_tot*Vref+Cp_tot*Vinp)/Cp_tot;%以上内容的解，简化程序
new_Vxn=(Cn*Fb*Vref-Cn_tot*Vref+Cn_tot*Vinn)/Cn_tot;
Energy=Energy + Cp*(abs((new_Vxp*ones(N,1)-Ft*Vref)-(Vxp*ones(N,1)-old_Ft*Vref)).^2) + Cn*(abs((new_Vxn*ones(N,1)-Fb*Vref)-(Vxn*ones(N,1)-old_Fb*Vref)).^2);
%根据开关形态计算功耗
for i=1:N-1
    Vxp=(Cp*Ft*Vref-Cp_tot*Vref+Cp_tot*Vinp)/Cp_tot;%以上内容的解，简化程序
    Vxn=(Cn*Fb*Vref-Cn_tot*Vref+Cn_tot*Vinn)/Cn_tot;
    old_Ft=Ft;
    old_Fb=Fb;
    if Vxp >= Vxn
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
    new_Vxp=(Cp*Ft*Vref-Cp_tot*Vref+Cp_tot*Vinp)/Cp_tot;%以上内容的解，简化程序
    new_Vxn=(Cn*Fb*Vref-Cn_tot*Vref+Cn_tot*Vinn)/Cn_tot;
    if i<N-1
    Energy=Energy + Cp*(abs((new_Vxp*ones(N,1)-Ft*Vref)-(Vxp*ones(N,1)-old_Ft*Vref)).^2) + Cn*(abs((new_Vxn*ones(N,1)-Fb*Vref)-(Vxn*ones(N,1)-old_Fb*Vref)).^2);
    end
    %根据开关形态计算功耗
end
E=[E;Energy];
adco=[adco;A];
end
Energy_mean=sum(E)/length(E);