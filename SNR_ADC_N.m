function [SNDR,SFDR,ENOB,SNR]=SNR_ADC_N(adco,N)
len= length(adco);

Fs=100e6;


x = zeros (len ,N );
z = zeros (len ,1 );
x=(adco>=0.9);
%  x(1,:)
%  x(2,:)
%  x(3,:)
%  x(4,:)
%  x(5,:)
%  x(6,:)
%  x(7,:)
%  x(8,:)
%  x(9,:)
%  x(10,:)
ii = 1;
for ii = 1:len
    z(ii,1)=(2*x(ii,1)-1)/2;
    for t=2:N
        z(ii,1)=z(ii,1) + (2*x(ii,t)-1)/(2^t);
    end    
%   z(ii,1)=(2*x(ii,1)-1)/2+(2*x(ii,2)-1)/4+(2*x(ii,3)-1)/8+...
%       (2*x(ii,4)-1)/16+ (2*x(ii,5)-1)/32+ (2*x(ii,6)-1)/64+...
%       (2*x(ii,7)-1)/128+(2*x(ii,8)-1)/256+(2*x(ii,9)-1)/512+...
%       (2*x(ii,10)-1)/1024+(2*x(ii,11)-1)/2048+(2*x(ii,12)-1)/4096+...
%       (2*x(ii,13)-1)/8192+(2*x(ii,14)-1)/16384;
  ii=ii+1;
end;
n=0:1:len-1;
w=hodiewindow(len);
xn=(z.*w);
XK =abs(fft(xn))/len*2;
for t=1:N/2
XK(t) =0;
end
AXK = XK(1:len/2);
[MAXsignal , frequency] = max (AXK);

AXKlog = 20*log10(AXK);

AXK2 = AXK.^2;
AXK2log = 10*log10 (AXK2);
power = sum(AXK2log);

 
 %figure(1);
 %plot(n,z,'bo-');

K = (0:len/2-1) ;
% figure(2);
% plot((K/len)*Fs/1000,20*(log10(AXK/max(AXK))),'b.-');

power = sum(AXK2);
size =N/2;
AXK(frequency - size : frequency + size) = zeros(1 , N+1);
signalpower = sum(AXK2(frequency-size : frequency+size));
SNDR = 10*log10(signalpower/(power - signalpower));

[wave, wavefre] = max(AXK);
SFDR = 20*log10(abs(MAXsignal/wave));
ENOB=(SNDR - 1.76)/6.02;

bw=Fs/2;
vo=z;
Ns=len;

w=hodiewindow(Ns);

% figure(1)
% plot(1:Ns,vo,'bo-');
% grid on;
%afft = abs(fft(vo))/Ns*2;
afft = abs(fft(vo.*w))/Ns*2;
s = afft(1:Ns/2);
z=N/2;
sg = s;
sg(1:z-1) = 0;
[x,bx] = max(sg);
%bd3= Ns*(40e6-fx*3)/Fs +1;
%bd2= Ns*fx*2/Fs +1;
Asignal = 10*log10(sum(sg(bx-z:bx+z).^2));
%Ad3=10*log10(sum(s(bd3-z:bd3+z).^2));

 varr = 10*log10(sum(s(bx).^2));
%  figure(2);
%  plot((0:Ns/2-1)/Ns*Fs,20*(log10(s))-varr,'bo-');
%  grid on;


sn = s;
DCsignal = 10*log10(sum(sn(1:z-1).^2));
% disp('DC:');
% disp(DCsignal);

%Nsn=length(sn);
sn(1:z-1)=0;
sn(bx-z:bx+z) = 0;
ANHD = 10*log10(sum(sn(1:ceil(Ns*bw/Fs)-1).^2));      %Anoise

z1=4;
[y,by] = max(sn);
HD3 = 10*log10(sum(s(by-z1:by+z1).^2));     %HD3
sn(by-z1:by+z1) = 0;

[y,by] = max(sn);
HD2 = 10*log10(sum(sn(by-z1:by+z1).^2));    %HD2
sn(by-z1:by+z1) = 0;

z1=4;
num = N/2;
thd = zeros(1,num);
for i=1:num
    [xx,thd(i)] = max(sn);
    sn(thd(i)-z1:thd(i)+z1) = 0;    
end; 
Anoise = 10*log10(sum(sn(1:ceil(Ns*bw/Fs)-1).^2));       %SNR (SNDR without the top 9 HD)

snn = sn;
snn(bx-z:bx+z) = s(bx-z:bx+z); 
%figure(3);
%plot((0:Ns/2-1)/Ns*Fs,20*(log10(snn)),'bo-');
%disp('SNR:');
SNR = Asignal - Anoise; 
% disp(SNR);
end