# Digital Calibration of SAR ADC

**Successive Approximation Register (SAR) ADC Digital Calibration**

*   [Overview](#overview)
    *   [Code](#code)
*   [Theory](#theory)
    *   [Charge Redistribution](#CR_theory)
    *   [Redundant](#RD_theory)
*   [Tutorial](#tutorial)
   *  [Matlab](#matlab)
   *  [Mathtype](#mathtype)
   *  [Latex](#latex)
   *  [Markdwon](#markdown)
   *  [Matplotlib](#matplotlib)
   
<h2 id="overview">Overview</h2>

<h3 id="code">Code</h3>

This Code part contains:

1. An executable file ([Run_SAR_ccliu.m](https://github.com/zlijingtao/Digital-Calibration-of-SAR-ADC/blob/master/Run_SAR_ccliu.m)) to auto-test the ADC model and output its dynamic performance and also the averaging energy consumption.

2. Behavioral Model file ([SAR_ccliu.m](https://github.com/zlijingtao/Digital-Calibration-of-SAR-ADC/blob/master/SAR_ccliu.m)) of a popular SAR ADC architecture proposed by Liu et al. [1].

3. Fast Fourier Transfromation (FFT) file ([SNR_ADC.m](https://github.com/zlijingtao/Digital-Calibration-of-SAR-ADC/blob/master/SNR_ADC.m)) to test the dynamic performance of the SAR ADC beharvioral model.

4. Hodiewindow function file ([hodiewindow.m](https://github.com/zlijingtao/Digital-Calibration-of-SAR-ADC/blob/master/hodiewindow.m)) which is needed for doing the FFT.

5. Err_compare function file ([err_compare.m](https://github.com/zlijingtao/Digital-Calibration-of-SAR-ADC/blob/master/err_compare.m)) to emulate the decision error occurs in the SAR process.

6. Behavioral Model file ([SAR_conventional.m](https://github.com/zlijingtao/Digital-Calibration-of-SAR-ADC/blob/master/SAR_conventional.m)) of the conventional SAR ADC architecture in [1], newly uploaded by Whove.

7. Behavioral Model file ([SAR_ccliu_10b_rd.m](https://github.com/zlijingtao/Digital-Calibration-of-SAR-ADC/blob/master/SAR_ccliu_10b_rd.m)) of redundant algorithm proposed in [2].

8. Full adder function file ([full_adder.m](https://github.com/zlijingtao/Digital-Calibration-of-SAR-ADC/blob/master/full_adder.m)) to implement the full-adder.

<h2 id="theory">Theory</h2>

<h3 id="CR_theory">Charge Redistribution</h3>

See the PDF file ([Proposed SAR ADC.pdf](https://github.com/zlijingtao/Digital-Calibration-of-SAR-ADC/blob/master/Proposed%20SAR%20ADC.pdf)). It well explains the "Charge Redistribution Theory" of the proposed ADC architecture in [1].

<h3 id="RD_theory">Redundant</h3>

The redundant is a design method for mitigating the effect of decision error occurs in SAR ADC. The decision error is a settling problem during the charge redistribution. (for more info, please refer to Liu et al. [2].)

The implementation of the redundant in a 10-b SAR ADC is like this:

<img src="https://i.loli.net/2018/03/30/5abdd01084c08.jpg" width="75%" height="75%" />

* * *
**Reference**

[1]: [Liu et al. - 2010 - A 10-bit 50-MSs SAR ADC with a monotonic capacitor switching procedure](http://ieeexplore.ieee.org/abstract/document/5437496/).

[2]: [Liu et al. - 2010 - A 10b 100MSs 1.13mW SAR ADC with binary-scaled error compensation](http://ieeexplore.ieee.org/abstract/document/5433970/)

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

Markdown语言是一种轻量化的标记语言，支持[HTML](http://www.w3school.com.cn/html/html_jianjie.asp)。

用处：写blog，写readme，分享自己的idea。

Markdown教程：[othree的Markdwon简明教程](https://github.com/zlijingtao/markdown-syntax-zhtw/blob/master/syntax.md)

<h3 id="matplotlib">Matplotlib</h3>

Matplotlib是Python的一个功能强大的绘图库，可用于绘制各种fancy的图片。

需要提前安装[python](https://www.python.org/downloads/release/python-364/)

Matplotlib安装教程：[python:安装pylab模块](https://blog.csdn.net/bit_clearoff/article/details/52502654)

Matplotlib使用教程：[Matplotlib Tutorial(译)](http://reverland.org/python/2012/09/07/matplotlib-tutorial/)
