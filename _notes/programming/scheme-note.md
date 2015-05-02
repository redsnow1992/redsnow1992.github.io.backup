---
layout: document
title: Scheme/Racket Note
---
# Language Model
## Evaluation Model
~~~racket
(- 4 (+ 1 1)) -> (- 4 2) -> 2
~~~
**Expression -> Value**     
### Sub-expression Evaluation and Continuations
An expression that is not a value can always be partitioned into two parts:
a *redex*, which is the part that changed in a single-step simplication, and the *continuation*, which is the evaluation context surrounding an expression.
In `(- 4 (+ 1 1))`, the redex is `(+ 1 1)`, and the continuation is `(+ 4 [])`,where `[]` takes the place of the redex. That is, the continuation says how to "continue" after the redex is reduced to a value.
### Tail Position
An expression `expr1` is in tail position with respect to an enclosing expression `expr2` if, whenever `expr1` becomes a redex, its continuation is the same as was the enclosing `expr2`’s continuation.

For example, the `(+ 1 1)` expression is not in tail position with respect to `(- 4 (+ 1 1))`. To illustrate, we use the notation `C[expr]` to mean the expression that is produced by substituting expr in place of [] in the continuation C:

~~~racket
C[(- 4 (+ 1 1))] → C[(- 4 2)]
~~~
In this case, the continuation for reducing `(+ 1 1)` is `C[(- 4 [])]`, not just C.

In contrast, `(+ 1 1)` is in tail position with respect to `(if (zero? 0) (+ 1 1) 3)`, because, for any continuation C,

~~~racket
C[(if (zero? 0) (+ 1 1) 3)] → C[(if #t (+ 1 1) 3)] → C[(+ 1 1)]
~~~
The steps in this reduction sequence are driven by the definition of `if`, and **they do not depend on the continuation C**. The "then" branch of an `if` form is always in tail position with respect to the `if` form. Due to a similar reduction rule for `if` and `#f`, the "else" branch of an `if` form is also in tail position.

Tail-position specifications provide a guarantee about the *asymptotic space consumption of a computation*. In general, the specification of tail positions goes with each syntactic form, like `if`.


### The concept of continuations  

During the evaluation of a Scheme expression, the implementation must keep track of two things: 

1. what to evaluate 
2. what to do with the value.   

Scheme allows the **continuation of any expression** to be captured with the procedure `call/cc`. `call/cc` must be passed a procedure p of one argument. `call/cc` constructs a concrete representation of the current continuation and passes it to p. The continuation itself is represented by a procedure k. **Each time k is applied to a value, it returns the value to the continuation of the `call/cc` application**. This value becomes, in essence, the value of the application of `call/cc`.

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

~~~scheme
(define retry #f)
(define factorial
  (lambda (x)
    (if (= x 0)
        (call/cc (lambda (k) (set! retry k) 1))
        (* x (factorial (- x 1))))))
~~~

With this definition, factorial works as we expect factorial to work,
except it has the side effect of assigning retry.

~~~scheme
(factorial 4) =>                24 
(retry 1)     =>                24
(retry 2)     =>                48
~~~

The continuation bound to retry might be described as "Multiply the value by 1, then multiply this result by 2, then multiply this result by 3, then multiply this result by 4." If we pass the continuation a different value, i.e., not 1, we will cause the base value to be something other than 1 and hence change the end result.

~~~scheme
(retry 2)   =>            48 
(retry 5)   =>            120
~~~

| racket | ruby |
| -- | -- |
| (string-append "rope" "twine" "yarn") | +, << |
| (substring "corduroys" 0 4) | [0..4] |
| (string-length "shoelace") | .length |
| (string? "Ceci n'est pas une string.") | is_a?(String) |
| (sqrt 16) | 
| (number? 1) |
| (equal? 6 6) |
| (hash "apple" 'red "banana" 'yellow) | {} |
| (hash-set ht "coconut" 'brown) | [] |
| (string #\A #\p #\p #\l #\e) |   |
| (string-upcase "abc!") | |
| (string-titlecase "aBC  twO") | | 
| (string-join '("x" "y" "z") ", "               #:before-first "Todo: "               #:before-last " and "               #:after-last ".") | |
|(string-normalize-spaces "  foo bar  baz \r\n\t") | |
| (string-replace "foo bar baz" "bar" "blah") |  |
| (~a 'south) => "south" | |