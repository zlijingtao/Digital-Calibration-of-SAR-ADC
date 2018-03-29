function output=err_compare(i,j,error_rate)
% this function is a comparison function which is likely to fail at a
% certain error_rate.
%error_rate is a float number between 0 and 1. i.e.: 0.10.
%i,j are two numbers which needs for comparison.
%the output of this function is either "1" or "0".
q=rand(0,1);
if i<j
if q<error_rate
    output=1;
else
    output=0;
end
else
if q<error_rate
    output=0;
else
    output=1;
end
end
end
