clear all
clc
n=14;%The resolution must be an even number
[adco,energy]=SAR_ccliu(n)
[SNDR,SFDR,ENOB,SNR]=SNR_ADC_N(adco,n)
energy