# Digital Calibration of SAR ADC

**Successive Approximation Register (SAR) ADC Digital Calibration**

*   [Overview](#overview)
    *   [Code](#code)
    *   [Theory](#theory)
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

<h3 id="theory">Theory</h3>

The theory part contains:

1. A PDF file (Proposed SAR ADC.pdf) to explain the "Charge Redistribution Theory" of the proposed ADC architecture.

* * *
**Reference**

[1]: [Liu et al. - 2010 - A 10-bit 50-MSs SAR ADC with a monotonic capacitor switching procedure](http://ieeexplore.ieee.org/abstract/document/5437496/).

* * *

<h2 id="tutorial">Tutorial</h2>

<h3 id="matlab">Matlab</h3>

Matlab is a powerful tool to conduct scientific research and implement your ideas.

用处：用于数学建模及仿真。

Matlab教程：[Matlab官方教程](https://cn.mathworks.com/support/learn-with-matlab-tutorials.html?s_tid=hp_ff_l_tutorials)

比看教程更有效率的学习方法：直接上手，遇到不懂的直接baidu。

<h3 id="mathtype">Mathtype</h3>

Mathtype is a tool to type your mathematical equations.

用处：用于公式编辑。

Mathtype极为简单，易于上手。

需要注意的地方：
在Preference->Cut and Copy Preference 中，可以对拷贝的输出格式进行设置，默认为Equation Object， 适合直接拷贝进word中；还有MathML格式，适合拷贝进Latex中，极为方便。

<h3 id="latex">Latex</h3>

Latex is a high-quality typesetting system; it includes features designed for the production of technical and scientific documentation.

用处：用于论文写作。

Latex教程：[LaTeX新人教程，30分钟从完全陌生到基本入门](http://blog.sina.com.cn/s/blog_90444ed201016iq6.html)

<h3 id="markdown">Markdown</h3>

Markdown语言是一种轻量化的标记语言，支持HTML。

用处：写博客，在Github写readme，分享自己的idea。

Markdown教程：[othree的Markdwon简明教程](https://github.com/zlijingtao/markdown-syntax-zhtw/blob/master/syntax.md)
