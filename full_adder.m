function [sum,Cout]=full_adder(A,B,Cin)
sum=xor(xor(A,B),Cin);
Cout=(A&B)|(Cin&(A|B));
end