# Digital-Calibration-of-SAR-ADC
**Successive Approximation Register (SAR) ADC Digital Calibration**

This Open-source Project contains:

1. A Run file (Run_SAR_ccliu.m) to auto-test the ADC model and output its dynamic performance and also the averaging energy consumption.

2. Behavioral Model file (SAR_ccliu.m) of a popular SAR ADC architecture proposed by Liu et al. [1].

3. Fast Fourier Transfromation (FFT) file (SNR_ADC.m) to test the dynamic performance of the SAR ADC beharvioral model.

4. Hodiewindow function file (hodiewindow.m) which is needed for doing the FFT.

5. A descrption file (Proposed SAR ADC.pdf) to explain the "charge redistribution mechanism" of the proposed ADC architecture.

6. Capacitor Mismatch Calibration Method I and II from our unpublished work (unavailable now).

**Reference**

[1] Liu et al. - 2010 - A 10-bit 50-MSs SAR ADC with a monotonic capacitor switching procedure.

