clear all
clc
n=14;%This n must be an even number and usually larger than 4.
[adco,energy]=SAR_ccliu(n)
[SNDR,SFDR,ENOB,SNR]=SNR_ADC(adco,n)
energy
