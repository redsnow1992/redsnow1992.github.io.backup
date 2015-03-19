---
layout: document
title: 偶有所得
---

## 从哪里开始学
   在网易公开课《线性代数》的学习中，Gilbert对于定义的东西都是在一节课的最后才讲的，更多的是
   先介绍几个例子，然后提出几点基本性质，运用这些性质。在介绍行列式计算的时候，更是如此。让整个
   学习过程不再觉得艰难，因为行列式计算的公式咋看之下确实挺复杂的，很多人在了解这个定义之后，就直接
   不知所向了。而在实际的行列式计算中，直接应用定义来做却是很少的情况，更多的是应用各种计算性质。而
   首先介绍性质也更容易理解整个行列式，毕竟性质是非常重要的，有时候，一个性质也往往可以定义一个东西、
   物体等，就像Ruby这种语言所提倡的Ducking Type那样。

### 小聪哥在日志中发现的游戏  
游戏题目如下：  
找出图中X所代表的数字  
26 16 06 68 88 X 98  
当时他是在手机上看到这个题目的，然后把手机拿给我，让我来试着解一下，我看了一会儿，没头绪，就把手机给整个倒过来了，然后就得出了答案。  
过了一会，又想到，之所以可以很快解出来，一个很重要的外部因素便是，当时我是在手机上看的，如果是在电脑上看，可能会因为转动屏幕或者转动脑袋（这样做的成本带大，有时会自动忽略这种方法，甚至在潜意识中都不会出现），而不会想到这种方法。唯一的就只能想像图片倒转过来的样子。 

*2014-06-03*

## MIT linear algebra
### [MIT linear algebra 体积与行列式](http://v.163.com/movie/2010/11/0/C/M6V0BQC4M_M6V2AQ40C.html)
若空间中的体积满足课中提到的1～3性质，则可以确定体积为行列式的绝对值。    
三角形(x1,y1; x2,y2; x3,y3) 行列式 

$$
\begin{matrix}
x_{1} & y_{1} & 1 \\
x_{2} & y_{2} & 1 \\ 
x_{3} & y_{3} & 1 \\
\end{matrix}
$$

消元法，把点划到原点     
以属性来确定研究的对象。    
欧拉公式与矩阵的秩     

### MIT linear algebra 特征值与特征向量
$$ \lambda * I * X = \lambda * X $$  ( $$ \lambda*I $$ 是一个矩阵, 总有特征值 $$ \lambda $$ )    
$$ Ax = \lambda * x   $$
*2014-11-13*

###  傅立叶级数，马尔科夫矩阵
函数的正交，将函数看作一组连续的值     
总是问的问题：这个矩阵的四大空间？这个行列式的特征值，特征向量？以这些基础问题来不断地让自己自下而上的看问题。   

### 对数函数和反三角函数的导数
在此之前先介绍了链式法则，通过该法则可以推出逆函数的导数。
$$
\begin{align*}
f^{-1}(f(x))=x  \\
f(f^{-1}(y))=y   \\
eg: e^{lny}=y, ln(e^x)=x  \\
arcsin^{-1}(x)=\frac{1}{\sqrt{1-x^2}}\qquad  \\
arccos^{-1}(x)=\frac{-1}{\sqrt{1-x^2}}\qquad \\
from\quad the\quad graph\quad we\quad can\quad get:
arcsin(x)+arccos(x) = constant = pi/2
\\
end{align*}
$$
### 负增长率和对数图
$${(\frac{n!}{n^n})}^{\frac1{n}}=\frac1{e} $$  \\
#### log scale
$$
\begin{align*}
y=Ax^n \qquad\qquad  => logy=logA+nlogx    \qquad a\;straight\;line\; in\; logx-logy\; axis
y=B10^{xc} \qquad\qquad => logy=logB+xc \ in base \ 10; also a\ straight\ line in x-logy\ axis
\end{align*}
$$
the $$ e^x $$ is equally spaced
#### error
$$
\begin{align*}
E = \frac{df}{dx} - \frac{\Delta{f}}{\Delta{x}} \approx A(\Delta{x})^n
\end{align*}
$$
What is the n? \\
n=1 \\
if change to the following? \\

E = \frac{df}{dx} - \frac{f(x+\Delta{x}) - f(x-\Delta{x})} {2\Delta{x}} \approx A(\Delta{x})^n
\]
n=2 \\

### 指数函数
start from $$ \frac{dy}{dx} = y  $$
$$
\begin{align*}
y = 1   \\
\frac{dy}{dx} = 1 \\
y = 1 + x \\
\frac{dy}{dx} = 1 + x  \\
y = 1 + x + \frac{x^2}2 \\
\frac{dy}{dx} = 1 + x + \frac{x^2}2 \\
\ldots
\end{align*}
$$
in bank, the interest computation \\
if the  year interest ratio is 100% \\
1 2 3 4   year..  \\
1 2 4 8   \\
1 $$ 1+\frac1{12} $$ $$ (1+\frac1{12})^2 $$ \\
...  $$ (1+\frac1{n})^n $$
### 线性近似和牛顿法 
Following the line.   \\
Fix using derivate.    
#### Linear Approximation (find $$ f(x)  $$)
at $$ x=a $$,  $$  \frac{df}{dx}=f^{'}(a)  \approx \frac{f(x)-f(a)}{x-a}  $$ \\
$$   f(x)\approx f(a)+(x-a)f^{'}(a)    $$  \\
Eg. find $$  \sqrt{9.06}  $$ \\
$$  e^{0.01} \approx 1+x+\ldots   $$  *get error order*.
  
#### Newton's Method (solve $$  F(x)=0  $$)
from above: \\
$$  \frac{-F(a)}{x-a}=F^{'}(a)    $$ \\
$$  x-a \approx \frac{-F(a)}{f^{'}(a)}   $$ \\
Eg. $$  F(x) = X^2-9.06  $$

### 幂级数和欧拉公式 
$$  f(x)=a_0 + a_1x + a_2x^2+\ldots + a_nx^n  $$  \\
Match at $$  x = 0 \qquad,  $$ $$  f(0) \ f^{'}(0) \ f^{''}(0) \ f^{'''}(0)  $$ \\
$$  e^{i\theta} = cos\theta+sin\theta  $$  \\
$$  e^{i\pi} = -1  $$ \\
geometric series \\
$$  \frac1{1-x} = 1+x+x^2+x^3+\ldots + x^n + \ldots   $$ \\
$$  \int  $$ \\
$$  -ln(1-x) = x + \frac{x^2}2 + \frac{x^3}3 + \ldots  $$ \\

### 关于运动的微分方程
solve $$  my^{''}+2ry^{'}+ky = 0  $$  \\
eg: $$  \frac{d^2y}dt^2=ay \qquad gives: y=Ce^{at}   $$ \\
$$  \frac{d^2y}dt^2=-{\omega}^2y \qquad gives: y=Ccos{\omega}t + Dsin{\omega}t $$ \\
$$  \frac{d^2y}dt^2 = 0 \qquad gives: y= C+DT  $$ \\
What are the combination of those?
Try $$  y = e^{\lambda t}  $$ \\
$$  \lambda = \frac{-r\pm \sqrt{r^2-km}}m  $$
when $$  \lambda = 0; the\ answer\ has\ te^{\lambda t}  $$

### 关于增长的微分方程
$$  \frac{dy}{dt}=cy+s \;;h s\ is\ source   $$   \\
change to the form: $$  \frac{d(y+\frac{s}c)}{dt}=c(y+\frac{s}{c})  $$ \\
solution: $$  y(t)+\frac{s}c=(y(0)+\frac{s}{c})e^{ct}  $$  \\
Linear equation solution: \\
$$  y(t) = y(t)_{particular}+y_{rightside=0}   $$  \\
right_hand_side = 0 is homogeneous equation \\

non-linear equation: \\
population growth: (which model?) \\
$$  \frac{dP}{dt}=cP-sP^2  $$  c for growth rate, s for slow down factors \\
Picture the function: (S-curve)\\
1. P = 0
2. $$  \frac{dP}{dt}=0 \qquad=> \qquad P=\frac{c}s   $$ \\
Try $$  y=\frac1P  $$
we get: $$  \frac{dy}{dt} = s-cy \qquad=> y(t)-\frac{s}c = (y(0)-\frac{s}c)e^{-ct}  $$  \\
the above is logistic equation. \\

Predator-Prey Equation: \\
$$
\begin{align*}
\frac{du}{dt} = -c_1u + s_1uv   \qquad predator
\frac{dv}{dt} = c_2v - s_2uv    \qquad prey
\end{align*}
$$

### 六大函数、六大法则及六大定理
6 Functions: 
1. $$  x^n  $$
2. $$  sinx  $$
3. $$  cosx  $$
4. $$  e^{cx}  $$
5. $$  lnx  \qquad xlnx-x  $$
6. step function

6 Rules:
1. $$  af(x)+bg(x) \rightarrow a\frac{df}{dx}+b\frac{dg}{dx}  $$
2. $$  f(x)g(x) \rightarrow f(x)\frac{dg}{dx}+g(x)\frac{dy}{dx}  $$
3. $$  \frac{f(x)}{g(x)} \rightarrow g(x)\frac{df}{dx}-f(x)\frac{dg}{dx}  $$ 
4. $$  x=f^{-1}(y) \rightarrow \frac{dx}{dy}=\frac1{\frac{dy}{dx}}  $$
5. $$  f(g(x)) \rightarrow \frac{df}{dy}\frac{dy}{dx}  $$
6. $$  l^{'}Hopital \; when g(x)\rightarrow 0  \; f(x) \rightarrow 0 \qquad \frac{f(x)}{g(x)} \rightarrow \frac{df/dx}{dg/dx} \; x\rightarrow a $$

6 Theorems:
1. Fundamental Theorem of Calculus
   + If $$  f(x)=\int^{x}_{a}s(t)dt \; then \; \frac{df}{dx}=s(x)  $$ \\
   + If $$  \frac{df}{dx}=s(x) \; then \; \int^{b}_{a}=f(b)-f(a)=f_{end}-f_{start}  $$
2. All values theorem for continuous function
   + $$  f(x)  $$ reaches its max M and it min m and all values between  $$  a\le x \le b  $$
3. Mean Value Theorem
   + If (fx) has a derivative   $$  a\le x \le b  $$
    Then $$  \frac{f(b)-f(a)}{b-a}=\frac{df}{dx}(c)  $$ c between  $$  a\le x \le b  $$
4. Taylor series(x near a, infinit series)
   + $$  f(x)=f(a)+f^{'}(a)(x-a) + \frac1{2!}f^{''}(a)(x-a)^2 + \ldots  $$
5. Remainder after $$  (x-a)^n  $$ term  is $$  \frac1{(n+1)!}f^{n+1}(c)(x-a)^{n+1}  $$
6. Binomial Theorem = Taylor at $$  a=0  $$
   + $$ (1+x)^n  $$ pascal triangle, stop at some where. Because the n is integer.

 
## 名言
### 丘成桐曰：“用已知的方法解决未知的问题不是搞科学研究，用未知的方法解决已知的问题才是搞科学研究。”

------
