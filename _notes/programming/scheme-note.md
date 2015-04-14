---
layout: document
title: Scheme Note
---
### The concept of continuations  

During the evaluation of a Scheme expression, the implementation must keep track of two things: 

1. what to evaluate 
2. what to do with the value.   

Scheme allows the continuation of any expression to be captured with the procedure `call/cc`. `call/cc` must be passed a procedure p of one argument. `call/cc` constructs a concrete representation of the current continuation and passes it to p. The continuation itself is represented by a procedure k. Each time k is applied to a value, it returns the value to the continuation of the `call/cc` application. This value becomes, in essence, the value of the application of `call/cc`.

If p returns without invoking k, the value returned by the procedure
becomes the value of the application of `call/cc`.
Consider the simple examples below.

{% highlight scheme %}
(call/cc
  (lambda (k)
    (* 5 4)))      =>    20
(call/cc
  (lambda (k)
    (* 5 (k 4))))  =>    4
{% endhighlight %}

Here is a less trivial example, showing the use of `call/cc` to provide a nonlocal exit from a recursion.

{% highlight scheme linenos %}
(define product
  (lambda (ls)
    (call/cc
      (lambda (break)
        (let f ([ls ls])
          (cond
            [(null? ls) 1]
            [(= (car ls) 0) (break 0)]
            [else (* (car ls) (f (cdr ls)))]))))))
{% endhighlight %}

Each of the continuation invocations above return to the continuation while control remains within the procedure passed to `call/cc`.

~~~scheme
(let ([x (call/cc (lambda (k) k))])
  (x (lambda (ignore) "hi")))  => "hi"

(let ([x (call/cc (lambda (k) k))])
  (x (lambda (ignore) ignore)))  => #<procedure>
~~~
The continuation captured by this invocation of `call/cc` may be described as "Take the value, bind it to `x`, and apply the value of `x` to the value of `(lambda (ignore) "hi")`." Since `(lambda (k) k)` returns its argument, `x` is bound to the continuation itself; this continuation is applied to the procedure resulting from the evaluation of `(lambda (ignore) "hi")`.This has the effect of binding `x` (**again!**) to this procedure and applying the procedure to itself. The procedure ignores its argument and returns "hi".

~~~scheme
(((call/cc (lambda (k) k)) (lambda (x) x)) "HEY!") => "HEY!" 
~~~
The value of the `call/cc` is its own continuation, as in the preceding example. This is applied to the identity procedure `(lambda (x) x)`, so the `call/cc` returns a second time with this value. Then, the identity procedure is applied to itself, yielding the identity procedure.

Consider the following definition of factorial that saves the continuation at the base of the recursion before returning 1, by assigning the top-level variable retry.

{% highlight scheme linenos %}
(define retry #f)
(define factorial
  (lambda (x)
    (if (= x 0)
        (call/cc (lambda (k) (set! retry k) 1))
        (* x (factorial (- x 1))))))
{% endhighlight %}

With this definition, factorial works as we expect factorial to work,
except it has the side effect of assigning retry.

{% highlight scheme %}
(factorial 4) =>                24 
(retry 1)     =>                24
(retry 2)     =>                48
{% endhighlight %}

The continuation bound to retry might be described as "Multiply the value by 1, then multiply this result by 2, then multiply this result by 3, then multiply this result by 4." If we pass the continuation a different value, i.e., not 1, we will cause the base value to be something other than 1 and hence change the end result.

{% highlight scheme %}
(retry 2)   =>            48 
(retry 5)   =>            120
{% endhighlight %}

