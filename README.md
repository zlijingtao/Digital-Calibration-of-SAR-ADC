# Digital-Calibration-of-SAR-ADC

**Successive Approximation Register (SAR) ADC Digital Calibration**

*   [Overview](#overview)
  * [Code](#code)
  * [Theory](#theory)

*   [Tutorial](#tutorial)
   *  [Matlab](#matlab)
   *  [Mathtype](#mathtype)
   *  [Latex](#latex)
   *  [markdwon](#markdown)
   
<h2 id="overview">Overview</h2>

<h3 id="code">Code</h3>

This Code part contains:

1. A Run file (Run_SAR_ccliu.m) to auto-test the ADC model and output its dynamic performance and also the averaging energy consumption.

2. Behavioral Model file (SAR_ccliu.m) of a popular SAR ADC architecture proposed by Liu et al. [1].

3. Fast Fourier Transfromation (FFT) file (SNR_ADC.m) to test the dynamic performance of the SAR ADC beharvioral model.

4. Hodiewindow function file (hodiewindow.m) which is needed for doing the FFT.

5. Capacitor Mismatch Calibration Method I and II from our unpublished work (unavailable now).

<h3 id="theory">Theory</h3>

The theory part contains:

1. A PDF file (Proposed SAR ADC.pdf) to explain the "Charge Redistribution Theory" of the proposed ADC architecture.

* * *
**Reference**

[1]: [Liu et al. - 2010 - A 10-bit 50-MSs SAR ADC with a monotonic capacitor switching procedure](http://ieeexplore.ieee.org/abstract/document/5437496/).

* * *

<h2 id="tutorial">Tutorial</h2>

<h3 id="matlab">Matlab</h3>

<h3 id="mathtype">Mathtype</h3>

<h3 id="latex">Latex</h3>

<h3 id="markdown">Markdown</h3>
