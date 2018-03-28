function window = hodiewindow(N)
% HODIEWINDOW(N)  window of length N
% based on code by Eric Swanson
% copyright 2001  Eric Swanson
%
window=zeros(N,1);
bottom=zeros(N,1);
top=2.5*ones(N,1);
index=[0:N-1]';
v=2*pi/N;
%
%Hodie window cosine coefficients
%
a0=0.61640321314050;
a1=0.98537119272586;
a2=0.49603771622007;
a3=0.14992232793243;
a4=0.02458719103474;
a5=0.00176604651487;
a6=0.00003158118857;
%
%coefficients sum to N
%
for m=1:N;
    n1=m-.5;
    window(m,1)=a0-a1*cos(v*n1)+a2*cos(v*2*n1)-a3*cos(v*3*n1)+a4*cos(v*4*n1)-a5*cos(v*5*n1)+a6*cos(v*6*n1);
end;
%
%plot
%
%plot(index,window,'-g',index,bottom,'-b',index,top,'-b');
%axis([0 30000 0 2.5]);
%axis off;
