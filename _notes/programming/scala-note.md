---
layout: document
title: Scala Note
---
## 1. Introduction

### 1. Functional programming is a restriction on how we write programs, but not on what programs we can write.

### 2. Referential transparency and purity
An expression e is referentially transparent if for all programs p , all
occurrences of e in p can be replaced by the result of evaluating e ,
without affecting the observable behavior of p . A function f is pure if the expression f(x) is referentially transparent for all referentially
transparent x .

### 3. run scala code
1. scalac file.scala; scala ModuleName
2. scala file.scala
3. run in scala; :load file.scala; ModuleName.fu; import ModuleName._

### 4. anonymous functions
{% highlight scala %}
private def show_msg(suffix: String, n: Int, f: Int => Int) = {
  val msg = "The %s of %d is %d"
  msg.format(suffix, n, f(n))
}

println(show_msg("increment", 7, (x: Int) => x + 1))
println(show_msg("increment2", 7, (x) => x + 1))
println(show_msg("increment3", 7, x => x + 1))
println(show_msg("increment4", 7, _ + 1))
println(show_msg("increment5", 7, x => { val r = x + 1; r }))

above anonymous functions don't need to declare (x: Int) => ...
because scala can infer from the function declaration.
{% endhighlight %}

## 2. Functional data structures

### 1. Single-Linked List
{% highlight scala linenos %}
package fpinscala.datastructures
sealed trait List[+A] // 1

case object Nil extends List[Nothing]  // 2
case class Cons[+A](head: A, tail: List[A]) extends List[A]

object List{  // 3
  def sum(ints: List[Int]): Int = ints match { // 4
    case Nil => 0
    case Cons(x, xs) => x + sum(xs)
  }

  def product(ds: List[Double]): Double = ds match {
    case Nil => 1.0
    case Cons(0.0, _) => 0.0
    case Cons(x, xs) => x * product(xs)
  }

  def apply[A](as: A*): List[A] = // 5
    if (as.isEmpty) Nil
    else Cons(as.head, apply(as.tail: _*))

  val example = Cons(1, Cons(2, Cons(3, NIL))) // 6
  val example2 = List(1,2,3)
  val total = sum(example)
}
{% endhighlight %}
1. List data type

    In general, we introduce a data type with the `trait` keyword. A `trait` is an abstract interface that may optionally contain implementations of some methods. Here we are declaring a trait , called `List` ,
    with no methods on it. Adding `sealed` in front means that all implementations of our trait must be declared in this file.

2. data constructor for List

    There are two such implementations or data constructors of List (each
    introduced with the keyword `case`)

3. List companion object
4. Patten match example
5. Variadic function syntax
6. Creating lists

I Think out the following Code after my thought.(It works!!)
{% highlight scala linenos %}
def hasSubsequence[A](ls: List[A], sub: List[A]): Boolean = {
    if(sub == Nil || ls == sub)
      true
    else
      ls match {
        case Nil => sub == Nil
        case Cons(x, xs) => sub match {
                              case Nil => false
                              case Cons(y, ys) => if(x == y)
                                                    hasSubsequence(xs, ys)
                                                  else
                                                    hasSubsequence(xs, sub)
                            }
      }
  }
{% endhighlight %}

### Tree
{% highlight scala %}
sealed trait Tree[+A]
case class Leaf[A](value: A) extends Tree[A]
case class Branch[A](left: Tree[A], right: Tree[A]) extends Tree[A]
{% endhighlight %}