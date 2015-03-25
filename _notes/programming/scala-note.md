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
3. run in scala; :load file.scala; ModuleName.fn; import ModuleName._

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

## Handling errors without exceptions
How then do we write functional programs which handle errors? The technique is based on a simple idea: instead of throwing an exception, we return a value indicating an exceptional condition has occurred. This idea might be familiar to anyone who has used return codes in C to
handle exceptions, although in FP it works a bit differently, as we'll see.

A function is typically partial because it makes some assumptions
about its inputs that are not implied by the input types.

A function may also be partial if it does not terminate for some inputs. We aren't going to discuss
this form of partiality here—a running program cannot recover from or detect this nontermination internally, so
there's no question of how best to handle it.

The solution is to represent explicitly in the return type that we may not always have a defined value. We can think of this as deferring to the caller for the error handling strategy. We introduce a new type, Option :

{% highlight scala %}
sealed trait Option[+A]
case class Some[+A](get: A) extends Option[A]
case object None extends Option[Nothing]

def mean(xs: Seq[Double]): Option[Double] =
  if (xs.isEmpty) None
  else Some(xs.sum / xs.length)
{% endhighlight %}

You'll see Option used throughout the Scala standard library, for instance:

- Map lookup for a given key returns Option
- headOption and lastOption defined for lists and other iterables return Option containing the first or last elements of a sequence if it is nonempty.

## Basic Structures
1. List
    
    >
        val l1 = List(1,2)
        val l2 = List(3,4)
        val l3 = l1 ::: l2   => (1, 2, 3, 4)
        var l4 = 1 :: l2     => (1, 3, 4)
        ::: concatenate
        ::  cons


    not append to lists

    scala List is immutable, ruby Array is mutable.

    | scala List | ruby Array |
    | () | [], at |
    | count | count |
    | drop, dropRight | delete_at |
    | exists | any? |
    | filter | select |
    | forall | all? |
    | foreach | each |
    | head | first |
    | init | [0..-2] |
    | isEmpty | empty? |
    | last | last |
    | length | length |
    | map | map,collect |
    | mkString | join |
    | remove | reject |
    | tail | [1..-1] |
    | sort | sort |
    | reverse | reverse |

2. Tuple

    tuples can contain different types of elements.
    Tuples are very useful, for example, if you need to return multiple objects from a method.

    >
        val pair = (99, "Luftballons")
        println(pair._1)
        println(pair._2)
        

3. Set and Map

    | scala Set | ruby Set |
    | += | set |
    | contains | include? |
    | scala Map | ruby Hash |
    | += | merge |
    | () | [] |



{% highlight scala %}
import scala.io.Source
  
if (args.length > 0) {

  for (line <- Source.fromFile(args(0)).getLines)
    print(line.length +" "+ line)
}
else
  Console.err.println("Please enter filename")
{% endhighlight %}

## Classes and Objects
1. sign usage and return type

    >
        scala> def g() { "this String gets lost too" }
        g: ()Unit
        scala> def h() = { "this String gets returned!" }
        h: ()java.lang.String
2. Singleton objects

    Scala is more object-oriented than Java is that classes in Scala cannot have static members. Instead, Scala has singleton objects. A singleton object definition looks like a class definition, except instead of the keyword class you use the keyword object .