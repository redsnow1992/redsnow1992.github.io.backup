---
layout: document
title: Scala Note
---
# Introduction
## Define variables
~~~scala
val msg = "hello"
val msg: java.lang.String = "hello"
~~~
## Define functions
~~~scala
def max(x: Int, y: Int): Int = {
  if (x > y)
    x
  else
    y
}
def max(x: Int, y: Int) = if (x > y) else y

def greet() = println("Hello")
=> greet: ()Unit
~~~
A result type of `Unit` indicates the function returns no interesting
value.
## Run scripts
hello.scala

~~~scala
println("hello, " + args(0) + "!")
~~~
`scala hello.scala`
## Loop
~~~scala
var i = 0
while(i < args.length){
  println(arg(i))
  i += 1
}
~~~
## Iterator
~~~scala
args.foreach(arg => println(arg))
args.foreach((arg: String) => println(arg))
args.foreach(println)
for(arg <- args)
  println(arg)
~~~
## Parameterize arrays with types
~~~scala
val big = new java.math.BigInteger("12425")
val greetingStrings = new Array[String](3)
greetingstrings(0) = "Hello"
greetingstrings(1) = ", "
greetingstrings(2) = "world!\n"
for(i <- 0 to 2) // (0).to(2)
  print(greetingstrings(i))

val greetingstrings: Array[String] = new Array[String](3)
~~~
Note that when you parameterize an instance with
both a type and a value, the type comes first in its square brackets, followed
by the value in parentheses.

The `to` in this example is actually a method that takes
one Int argument. The code `0 to 2` is transformed into the method call
`(0).to(2)`. Note that this syntax **only works if you explicitly specify the
receiver of the method call**. You **cannot** write `println 10`, but you can
write `Console println 10`.

When you apply parentheses surrounding one or more values
to a variable, Scala will transform the code into an invocation of a method
named `apply` on that variable. So `greetStrings(i)` gets transformed into
`greetStrings.apply(i)`.

This principle is not restricted to
arrays: any application of an object to some arguments in parentheses will
be transformed to an `apply` method call. Of course this will compile only
if that type of object actually defines an apply method. So it's not a special
case; it's a general rule.

Similarly, when an assignment is made to a variable to which parentheses
and one or more arguments have been applied, the compiler will transform
that into an invocation of an `update` method that takes the arguments in
parentheses as well as the object to the right of the equals sign. For example:

~~~scala
greetStrings(0) = "Hello"
~~~
will be transformed into:

~~~scala
greetStrings.update(0, "Hello")
~~~
**Initialize array in a concise way:**

~~~scala
val numNames = Array("zero", "one", "two")
val numNames = Array.apply("zero", "one", "two")
// apply like static method in java
~~~

## Use Lists
A Scala array is a mutable sequence of objects that all
share the same type. An `Array[String]` contains only strings, for example.
Although you can't change the length of an array after it is instantiated, you
can change its element values. Thus, arrays are mutable objects.   
Scala `List` s are always immutable.

~~~scala
val oneTwoThree = List(1, 2, 3)
::: concatenation
val oneTwo = List(1, 2)
val threeFour = List(3, 4)
val oneTwoThreeFour = oneTwo ::: threeFour
println(oneTwo +" and "+ threeFour +" were not mutated.")
=> List(1, 2) and List(3, 4) were not mutated.

val twoThree = List(2, 3)
val oneTwoThree = 1 :: twoThree
val oneTwoThree = 1 :: 2 :: 3 :: Nil
println(oneTwoThree)
~~~
If the method name ends in a colon, the method is
invoked on the right operand. Therefore, in `1 :: twoThree`, the `::` method
is invoked on twoThree, passing in `1`, like this: `twoThree.::(1)` .

**not append to lists**, use `::`+ `reverse` or `ListBuffer`(mutable list).
## Use Tuples
Tuples can contain different types of elements.    
if we want return multiple object from a method, we can return tuple.    
Once you have a tuple instantiated, you can access its elements
individually with a **dot, underscore, and the one-based index** of the element.

~~~scala
val pair = (99, "Luftballons")
println(pari._1)
~~~
We **cannot** use `pair(0)`, because a list's `apply` method always returns the
same type, but each element of a tuple may be a different type: `_1` can have
one result type, `_2` another, and so on.
## Use Sets and Maps
Scala provides mutable and immutable alternatives for sets and maps.

~~~scala
var jetSet = Set("Boeing", "Airbus")
jetSet += "Lear"
println(jetSet.contains("Cessna")

if change to:
val jetSet = Set("Boeing", "Airbus")
jetSet += "Lear"
// => error: value += is not a member of scala.collection.immutable.Set[String]
jetSet = jetSet + "Lear"
// => error: reassignment to val

import scala.collection.mutable.Set
val movieSet = Set("Hitch", "Poltergeist")
movieSet += "Shrek"
println(movieSet)
~~~

~~~scala
import scala.collection.mutable.Map
val treasureMap = Map[Int, String]()
treasuremap += (1 -> "Go to isLand")
treasuremap += (2 -> "Find big X on ground")
treasuremap += (3 -> "Dig.")
println(treasuremap(2)

val romanNumeral = Map(
  1 -> "I", 2 -> "II", 3 -> "III", 4 -> "IV", 5 -> "V")
~~~
## Orginize code in functional style
~~~scala
def printArgs(args: Array[String]: Unit = {
  args.foreach(println)
}  // its side effect is printing to standard output stream
vs
def formatArgs(args: Array[String]) = args.mkString("\n")
println(formatArgs(args))

// we can test
val res = formatArgs(Array("zero", "one", "two"))
assert(res == "zero\nnoe\ntwo") 
~~~
## Read lines from a file
~~~
import scala.io.Source
if(args.length > 0){
  for(line <- Source.fromFile(args(0)).getLines())
	println(line.length + " " + line)
}
else{
  Console.err.println("Please enter filename")	
}
~~~
# Classes and Objects
## Classes, fields and methods
~~~scala
class ChecksumAccumulator{
  private var sum = 0

  // def add(b: Byte): Unit = {
  //   sum += b
  // }	
  def add(b: Byte) { sum += b }

  def checksum(): Int = return ~(sum & 0xFF) + 1
}
new ChecksumAccumulator
~~~
One puzzler to watch out for is that whenever you leave off the equals
sign before the body of a function, its result type will
**definitely be `Unit`** .
This is true no matter what the body contains, because the Scala compiler
can convert any type to Unit.

~~~scala
scala> def f(): Unit = "this String gets lost"
warning: a pure expression does nothing in statement position; you may be
omitting necessary parentheses
      def f(): Unit = "this String gets lost"
		             ^
f: ()Unit

def g() = { "this String gets lost too" }
g: ()String
~~~
## Singleton objects
Scala is more object-oriented that Java is that classes in Scala cannot have
static members. Instead, Scala has `singleton objects` using `object` to define.

~~~scala
import scala.collection.mutable.Map

object ChecksumAccumulator {
  private val cache = Map[String, Int]()

  def calculate(s: String): Int =
    if (cache.contains(s))
      cache(s)
    else{
      val acc = new ChecksumAccumulator
      for(c <- s)
        acc.add(c.toByte)

      val cs = acc.checksum()
      cache += (s -> cs)
      cs
    }
}
ChecksumAccumulator.calculate("test")
~~~
When a singleton object shares the same name with a class, it is called
that class's `companion object`. You must define both the class and its
companion object in the same source file. The class is called the 
`companion class` of the singleton object. A class and its companion object
can access each other's private members.    
A singleton object is more than a holder of static methods, however. It is a
**first-class object**. You can think of a singleton object's name, therefore, as a "name tag" **attached to the object**.    
Singleton objects extend a superclass and can mix in traits.   
One difference between classes and singleton objects is that singleton
objects cannot take parameters, whereas classes can. Because you can't
instantiate a singleton object with the `new` keyword.
## A Scala application
~~~scala
import ChecksumAccumulator.calculate

object Summer{
  def main(args: Array[String]) {
    for(arg <- args)
      println(arg + ": " + calculate(arg))
  }
}

$ scalac ChecksumAccumulator.scala Summer.scala
$ fsc ChecksumAccumulator.scala Summer.scala

$ scala Summer of love
~~~
## The Application trait
Scala provides a trait, `scala.Application`, that can save you somd finger typing.

~~~scala
object FallWinnterSpringSummer extends Application {
  for(season <- List("fall", "winter", "spring"))
    println(season + ": " + calculate(season))
}
~~~
Instead of writing `main` method, we place the code we have put in the `main`
method directly between the curly braces of the singleton object.    
The code between the curly braces is collected into `primary constructor` of the
singleton object, and is executed when the class is initialized.

# Basic Types and Operations
## Some basic types
`Byte`,`Short`,`Int`,`Long`,and `Char` are called *integral types*.
The integral types plus `Float` and `Double` are called *numeric types*.
## Literals
**Integer literals**
> val hex = 0x00FF   
  val oct = 035   
  val prog = OXCAFEBABWEL   
  val long = 35L
  
**Floating point literals**
> val big = 1.234    
  val bigger = 1.245e1    
  val float = 1.234f   

**Character literals**
> val a = 'A'   
  val c = '\101'     // A   
  val d = '\u0041'   // A   
  val B\u0041\u0044 = 1  // BAD = 1  

**String literals**
> val hello = "hello"   
  val escapes = "\\\"\'"   
  val longString = """  fefafef """    
  val aligned = """|fef    
                   |next  """.stripMargin    
				   
**Symbol literals**    
A symbol literals is written *'ident*, where *ident* can be any alphanumeric
identifier. Ruby use ':' to indicate symbol.

~~~scala
val s = 'aSymbol
s.name // => aSymbol
~~~
## Operators are methods
`s indexOf ('o', 5)`, `indexOf` *is* an operator.**But** in `s.indexOf('o', 5)`,
`indexOf` is not an operator.
# Functional Objects
Functional Objects do not have any mutable state.   

The `Rational` class Example:

1. Constructing a `Rational`
2. Reimplementing the `toString` method
3. Checking preconditions
4. Adding fields(`that` could refer to)
5. Self references
6. Auxiliary constructors
7. Private fields and methods
8. Defining operators
9. Method overloading
10. Implicit conversions

In scala, every auxiliary constructors **must invoke another constructors**
of the same class as its first action.

~~~scala
class Rational(n: Int, d: Int){       // 1
  require(d != 0)            // 3
  private val g = gcd(n.abs, d.abs)  // 7

  val numer: Int = n / g   // 4
  val denom: Int = d / g   // 4

  def this(n: Int) = this(n, 1)     // 6

  override def toString = numer + "/" + denom  // 2

  def add(that: Rational): Rational =
    new Rational(numer * that.denom + that.numer * denom, denom * that.denom)

  def lessThan(that: Rational) =   // 5
    this.numer * that.denom < that.numer * this.denom

  def max(that: Rational) =  // 5
    if(this.lessThan(that)) that else this

  def + (that: Rational): Rational =  // 8
    add(that)

  def + (i: Int): Rational =  // 9
    new Rational(numer + i * denom, denom)

  private def gcd(a: Int, b: Int): Int =   // 7
    if (b == 0) a else gcd(b, a % b)
}
implicit def intToRational(x: Int) = new Rational(x) // 10
~~~

# Built-in Control Structures
~~~scala
var filename =
  if (!args.isEmpty) args(0)
  else "default.txt"

def gcdLoop(x: Long, y: Long): Long = {
  var a = x
  var b = y
  while(a != 0){
    val temp = a
	a = b % a
	b = temp
  }
  b
}

var line = ""
do{
  line = readLine()
  println("Read: " + line)
} while(line != "")
~~~

~~~scala
def greet() { println("hi") }
greet() == ()  // true
warning: comparing values of types Unit and Unit using '==' will always yield true

var line = ""
while((line = readLine()) != "")  // This is doesn't work
  println("Read: " + line)

warning: comparing values of types Unit and String using '!=' will always yield true
~~~
## In Scala assignment always results in the unit value, ()
~~~scala
1.to(4)    // scala.collection.immutable.Range.Inclusive = Range(1, 2, 3, 4)
1.until(4) // scala.collection.immutable.Range = Range(1, 2, 3)

val files = (new java.io.File(".")).listFiles
for(file <- files if file.getName.endsWith(".scala"))
  println(file)

for(
  file <- files
  if file.isFile
  if file.getName.endswith(".scala")
) println(file)
~~~
## Nested iteration
~~~scala
def fileLines(file: java.io.File) =
  scala.io.Source.fromFile(file).getLines().toList

def grep(pattern: String) =
  for(
    file <- files
	if file.getName.endsWith(".scala");
	line <- fileLines(file)
	trimmed = line.trim
	if trimmed.matches(pattern)
  ) println(file + ": " + trimmed)	

grep(".*gcd.*")
~~~

## Producing a new collection
~~~scala
def scalaFiles =
  for{
    file <- files
	if file.getName.endsWith(".scala")
  } yield file

for clauses yield body

for (file <- filesHere if file.getName.endsWith(".scala")) {
  yield file    // Syntax error!
}
~~~
**The `yield` goes before the entire body**.
## Exception handling with `try` expressions
**Throwing exceptions** 

~~~scala
val half =
  if (n % 2 == 0)
    n / 2
  else
    throw new RuntimeException("n must be even")
~~~

**Catching exceptions and `finally` clause**

~~~scala
import java.io.FileReader
import java.io.FileNotFoundException
import java.io.IOException

try {
  val f = new FileReader("input.txt")
} catch {
  case ex: FileNotfoundexception => // 
  case ex: IOException =>   // 
} finally {
  f.close()
}
~~~
**Yielding a value**   
If a `finally` clause includes an explicit return statement, or throws an
exception, that return value of exception will "overrule" any previous one
that originated in the `try` block or one of its `catch` clauses.

~~~scala
def f(): Int = try { return 1 } finally { return 2 }
f() // => 2

import java.net.URL
import java.net.MalformedURLException
def urlFor(path: String) =
  try {
    new URL(path)
  } catch {
    case e: MalformedURLException =>
      new URL("http://www.scala-lang.org")
  }
~~~
## Match expressions
~~~scala
val firstArg = if(args.length > 0) args(0) else ""
firstArg match {
  case "salt" => println("pepper")
  case "eggs" => println("bacon")
  case _ => println("huh?)
}
~~~
## Living without `break` and `continue`
~~~java
int i = 0;
boolean fountIt = false
while(i < args.length){
  if(args[i].startsWith("-")){
    i = i + 1 ;
	continue ;
  }
  if(args[i].endsWith(".scala")){
    fountIt = true ;
	break ;
  }
  i = i + 1 ;
}
~~~

~~~scala
var foundIt = false
for(arg <- args; if !foundIt)
  if(!arg.startsWith("-"))
    if(arg.endsWith(".scala"))
      foundIt = true
~~~


# Functions and Closures
## Methods
The most common way to define a function is as **a member of some object**.
Such a function is called `method`.

~~~scala
object FindLonglines{
  def function1() = {}
  private def function2() = {}
}
~~~
## Local functions
Define functions inside other functions.

~~~scala
def function1(para1) = {
  def function2() = {
    // can directly use para1 
  }

  // call function2
  function2()
}
~~~
## First-class functions
A function literal is compiled into a class that when instantiated at runtime
is a *function value*. The distinction between function literals and values
is that function literal exist in the source code, whereas function value exist
as objects at runtime.

~~~scala
var increase = (x: Int) => {
  x + 1
}
~~~
## Short forms of function literals
~~~scala
someNumbers.filter((x) => x > 0)
someNumbers.filter(x => x > 0)
~~~
## Placeholder syntax
~~~scala
someNumbers.filter(_ > 0)
someNumbers.foreach(println _)
val f = (_: Int) + (_: Int)
val f = (x: Int, _: Int) => x + _  // error!!
~~~
## Partially applied functions
A partially applied function is an expression in which you don't supply
all of the arguments needed by the function. Instead, you supply some, or
none, of the needed arguments.

~~~scala
def sum(a: Int, b: Int, c: Int) = a + b + c
val a = sum _
a: (Int, Int, Int) => Int = <function3>
val b = sum(1, _: Int, 3)
b: (Int) => Int = <function1>
~~~
## Closures
Closing the function literal by "capturing" the bindings of its free variables.

~~~scala
def inc(more: Int) = (x: Int) => x + more
val inc1 = inc(1)
val inc100 = inc(100)
~~~
## Special function call forms
**Repeated parameters**   

~~~scala
def echo(args: String*) =
  for (arg <- args) println(arg)
echo: (args: String*)Unit
echo("first", "second")
val arr = Array("What's", "up", "doc?")
echo(arr: _*)
~~~
**Named arguments**

~~~scala
def speed(distance: Float, time: Float): Float =
  distance/time
speed(time = 10, distance = 100)  // diff in invoking
~~~

**Default parameter values**

~~~scala
def printTime(out: java.io.PrintStream = Console.out) =
  out.println("time = " + System.currentTimeMillis())
def printTime2(out: java.io.PrintStream = Console.out, divisor: Int = 1) =
  out.println("time = " + System.currentTimeMillis()/divisor)

printTime2(out = Console.err)
printTime2(divisor = 1000)
~~~
# Control Abstraction
## Reducing code duplication
~~~scala
object FileMatcher {
  private def filesHere = (new java.io.File(".")).listFiles

  // def filesEnding(query: String) =
  //   for(file <- filesHere; if file.getName.endsWith(query))
  //     yield file

  def filesContaining(query: String) =
    for(file <- filesHere; if file.getName.contains(query))
      yield file

  def filesRegex(query: String) =
    for(file <- filesHere; if file.getName.matches(query))
      yield file

  def filesMatching(query: String, matcher: (String, String) => Boolean) = {
    for(file <- filesHere; if matcher(file.getName, query))
      yield file
  }

  def filesEnding(query: String) =
    filesMatching(query, (fileName, query) => fileName.endsWith(query))
    // filesMatching(query, _.endsWith(_))

  private def filesMatching(matcher: String => Boolean) =
    for(file <- filesHere; if matcher(file.getName))
    yield file

  def filesEnding(query: String) =
    filesMatching(_.endsWith(query))
}
~~~
## Simplifying client code
~~~scala
def containsNeg(nums: List[Int]) = nums.exists(_ < 0)
def containsOdd(nums: List[Int]) = nums.exists(_ % 2 == 1)
~~~
## Curring
A curried function is applied to multiple argument lists, instead of just
one.

~~~scala
def plainOldSum(x: Int, y: Int) = x + y

def curriedSum(x: Int)(y: Int) = x + y
curriedSum(1)(2)
curriedSum(1)  // error !!

def first(x: Int) = (y: Int) => x + y
first: (x: Int)(Int) => Int
first(2)       // right!!
~~~
## Writing new control structures
~~~scala
def twice(op: Double => Double, x: Double) = op(op(x))
twice(_ + 1, 5)  // => 7.0

def withPrintWriter(file: File, op: PrintWriter => Unit) {
  val writer = new PrintWriter(file)
  try{
    op(writer)
  } finally {
    writer.close()
  }
}

withPrintWriter(new File("date.txt"),
  writer => writer.println(new java.util.Date)
)
~~~
In any method invocation in Scala in which you're
passing in exactly one argument, you can opt to use curly braces to surround
the argument instead of parentheses.

~~~scala
println("Hello, world!")
println { "Hello, world!" }

def withPrintWriter(file: File)(op: PrintWriter => Unit){
   val writer = new PrintWriter(file)
  try{
    op(writer)
  } finally {
    writer.close()
  }
}

withPrintWriter(new File("data.txt")){
  writer => writer.println(new java.util.Date)
}
~~~
## By-name parameters
~~~scala
var assertionsEnabled = true
def myAssert(predicate: () => Boolean) =
  if (assertionsEnabled && !predicate())
    throw new AssertionError

myAssert(() => 5 > 3)
myAssert(5 > 3) // Won’t work, because missing () =>

def boolAssert(predicate: Boolean) =
  if (assertionsEnabled && !predicate)
    throw new AssertionError
boolAssert(5 > 3)

def byNameAssert(predicate: => Boolean) =
  if (assertionsEnabled && !predicate)
    throw new AssertionError

byNameAssert(5 > 3)
~~~
The expression `5 > 3` yields true , which is
passed to `boolAssert`.   
the expression inside the parentheses
in `byNameAssert(5 > 3)` is not evaluated before the call to `byNameAssert`.
Instead a function value will be created whose `apply` method will evaluate
`5 > 3`, and this function value will be passed to byNameAssert.

~~~scala
var assertionsEnabled = false
boolAssert(x / 0 == 0)    // yield an exception
byNameAssert(x / 0 == 0)  // no yield an exception
~~~
# Composition and Inheritance
we'll discuss:

1. abstract classes
2. parameterless methods
3. extending classes
4. overriding methods and fields
5. parametric fields
6. invoking superclass constructors
7. polymorphism and dynamic binding
8. final members and classes
9. factory objects and methods.

~~~scala
///  other file
import Element.elem

abstract class Element {                // 1
  def contents: Array[String]          // 2
  def height: Int = contents.length    // 2
  def width: Int = if(height == 0) 0 else contents(0).length  // 2

  // val height = contents.length    
  // val width = if(height == 0) 0 else contents(0).length

  def demo(){
    println("Element's implementation invokde")
  }

  def above(that: Element): Element =
    new ArrayElement(this.contents ++ that.contents)

  // def above(that: Element): Element =
  //   elem(this.contents ++ that.contents)

  def beside(that: Element): Element = {
    // val contents = new Array[String](this.contents.length)
    // for(i <- 0 until this.contents.length)
    //   contents(i) = this.contents(i) + that.contents(i)
    // new ArrayElement(contents)

    new ArrayElement(
      for(
        (line1, line2) <- this.contents zip that.contents
      ) yield line1 + line2
    )
  }

  override def toString = contents.mkString("\n")
}

// these definition can be moved to object Element
final class ArrayElement(conts: Array[String]) extends Element {   // 3, 8
  def contents: Array[String] = conts  // 4
  // val contents: Array[String] = conts  // 4

  final override def demo(){     // 8
    println("ArrayElement's implementation invokde")
  }
}

class LineElement(s: String) extends ArrayElement(Array(s)) {  // 6
  override def width = s.length
  override def height = 1

  override def demo(){
    println("LineElement's implementation invokde")
  }
}

class UniformElement(ch: Char, override val width: Int,
                     override val height: Int) extends Element {
  private val line = ch.toString * width
  def contents = Array.fill(height)(line)
}


class Cat {
  val dangerous = false
}
class Tiger (
  override val dangerous: Boolean,  // 4
  private var age: Int              // 5
) extends Cat

val e1: Element = new ArrayElement(Array("hello", "world")) // 7
val ae = new ArrayElement(Array("hello"))
val e2: Element = ae                           // 7
val e3: Element = new UniformElement('x', 2, 3)   // 7

def invokeDemo(e: Element){
  e.demo() 
}

invokeDemo(e2)   // 7
invokeDemo(new LineElement("test"))

object Element{   // 9
  def elem(contents: Array[String]): Element =
    new ArrayElement(contents)

  def elem(chr: Char, width: Int, height: Int): Element =
    new UniformElement(chr, width, height)

  def elem(line: String): Element =
    new LineElement(line)
}

val col1 = elem("hello") above elem("***")
val col2 = elem("***") above elem("world")
col1 beside col2
~~~

Methods defined with empty parentheses, such as `def height(): Int`, are called
*empty-paren methods*. The recommended convention is to use a parameterless
method whenever there are not parameters *and* the method accesses mutable
state only by reading fields of the containing object. This convention supports
the *uniform access principle*, which says that client code should not
be affected by a decision to implement an attribute as a field or method.

On the other hand, in Scala it is **forbidden** to define a field and method
with the same name in the same class, whereas it is **allowed** in Java.

Generally, Scala has just two namespaces for definitions in place of Java's
four. Java’s four namespaces are fields, methods, types, and packages. By
contrast, Scala’s two namespaces are:

+ values (fields, methods, packages, and singleton objects)
+ types (class and trait names)

**Using `override` modifiers**

+ Scala requires such a modifier for all members that
override a *concrete member* in a parent class.
+ The modifier is optional if a member implements *an abstract member*
with the same name.
+ The modifier is forbidden if a member does not override or implement
some other member in a base class.

To ensure a member cannot be overriden by subclasses, we add `final`
modifier to the member.

**factory object**    
A factory object **contains methods** that construct **other objects**. Clients
would then use these factory methods for object construction rather than
constructing the object directly with `new`.

# Traits
Traits are a fundamental unit of code reuse in Scala. A trait encapsulates
method and field definitions, which can then be reused by mixing them into
classes.
## How traits work
~~~scala
trait Philosophical {
  def philosophize() {
    println("I consume memory, therefore I am!")
  }
}

class Frog extends Philosophical {
  override def toString = "green"
}
~~~
Once a trait is defined, it can be *mixed* in to a class using either the
`extends` or `with` keywords.

~~~scala
val frog = new Frog
frog.philosophize()
~~~
A trait also defines a type. Here's an example in which `Philosophical` is
used as a type.

~~~scala
val phil: Philosophical = frog  // here trait acts as a superclass
phil.philosophize()
~~~
The type of `phil` is `Philosophical`, a trait. Thus, variable phil could have
been initialized with any object whose class mixes in `Philosophical`.

~~~scala
class Animal
trait HasLegs
class Frog extends Animal with Philosophical with HasLegs {
  override def toString = "green"

  override def philosophize() {
    println("It ain't easy being "+ toString +"!")
  }
}

val phrog: Philosophical = new Frog
phrog.philosophize()   // => "It ain't ... "
~~~
## Thin versus rich interfaces
One major use of traits is to **automatically add methods to a class** in terms
of methods the class **already has**.

~~~scala
trait CharSequence {
  def charAt(index: Int): Char
  def length: Int
  def subSequence(start: Int, end: Int): CharSequence
  def toString(): String
}
~~~
You only need to implement the method once, in
the trait itself, instead of needing to reimplement it for every class that mixes
in the trait.
## Example: Rectanglar objects
original class-version:

~~~scala
class Point(val x: Int, val y: Int)
class Rectangle(val topLeft: Point, val bottomRight: Point) {
  def left = topLeft.x
  def right = bottomRight.x
  def width = right - left
}

abstract class Component {
  def topLeft: Point
  def bottomRight: Point
  def left = topLeft.x
  def right = bottomRight.x
  def width = right - left
  // and many more geometric methods...
}
~~~
changed to trait-version:

~~~scala
trait Rectangular {
  def topLeft: Point    // abstract
  def bottomRight: Point   // abstract

  def left = topLeft.x     // concrete
  def right = bottomRight.x   // concrete
  def width = right - left    // concrete
}

abstract class Component extends Rectangular {
}
class Rectangle(val topLeft: Point, val bottomRight: Point) extends Rectangular {
}
~~~
## The Ordered trait
~~~scala
class Rational(n: Int, d: Int) extends Ordered[Rational] {
 //  ...
 def compare(that: Rational) =
   (this.numer * that.denom) - (that.numer * this.denom)

  /// not need to define >, <, <=, >=
}
~~~
## Traits as *statckable* modifications
Traits let you *modify* the methods of a class, and they do
so in a way that allows you to *stack* those modifications with each other.


+ **Doubling**: double all integers that are put in the queue
+ **Incrementing**: increment all integers that are put in the queue
+ **Filtering**: filter out negative integers from a queue

~~~scala
abstract class IntQueue {
  def get(): Int
  def put(x: Int)
}

import scala.collection.mutable.ArrayBuffer

class BasicIntQueue extends IntQueue {
  private val buf = new ArrayBuffer[Int]
  def get() = buf.remove(0)
  def put(x: Int) { buf += x }
}

trait Doubling extends IntQueue {
  abstract override def put(x: Int) { super.put(2 * x) }
}

class MyQueue extends BasicIntQueue with Doubling
// val queue = new BasicIntQueue with Doubling

trait Incrementing extends IntQueue {
  abstract override def put(x: Int) { super.put(x + 1) }
}

trait Filtering extends IntQueue {
  abstract override def put(x: Int) {
    if (x >= 0) super.put(x)
  }
}
~~~
~~~scala
val queue = (new BasicIntQueue with Incrementing with Filtering)
call put --> Filtering --> Incrementing --> BasicIntQueue

val queue = (new BasicIntQueue with Filtering with Incrementing)
~~~
## Why not multiple inheritance
Traits are a way to inherit from multiple class-like constructs, but they differ
in important ways from the multiple inheritance present in many languages.
One difference is especially important: the interpretation of `super`. With
multiple inheritance, the method called by a `super` call can be determined
right where the call appears. With traits, the method called is determined
by a *linearization* of the classes and traits that are mixed into a class. This
is the difference that enables the stacking of modifications described in the
previous section.

The main properties of Scala’s linearization are illustrated by the follow-
ing example:

~~~scala
class Animal
trait Furry extends Animal
trait HasLegs extends Animal
trait FourLegged extends HasLegs
class Cat extends Animal with Furry with FourLegged
~~~
arrows with white, triangular arrowheads indicate *inheritance*, with the
arrowhead pointing to the supertype. The arrows with darkened, non-triangular
arrowheads depict *linearization*. The darkened arrowheads point in the direction
in which super calls will be resolved.     
Each class **appears only once** in `cat`'s linearization.    
![scala_inheritance_linearization]({{ site.baseurl }}/images/cat.jpg)

## To trait, or not to trait?
Whenever you implement a reusable collection of behavior, you will have to
decide whether you want to use a trait or an abstract class. There is no firm
rule, but this section contains a few guidelines to consider:

+ If the behavior will not be reused, then make it a concrete class. It is not
reusable behavior after all.
+ If it might be reused in multiple, unrelated classes, make it a trait. Only
traits can be mixed into different parts of the class hierarchy.
+ If you want to inherit from it in Java code, use an abstract class.
+ If you plan to *distribute it in compiled form*, and you expect outside
groups to write classes inheriting from it, you might lean towards using an
abstract class. **The issue is that when a trait gains or loses a member, any
classes that inherit from it must be recompiled, even if they have not changed**.
**If outside clients will only call into the behavior, instead of inheriting from
it, then using a trait is fine**.
+ If efficiency is very important, lean towards using a class. Most Java
runtimes make a virtual method invocation of a class member a faster
operation than an interface method invocation. **Traits get compiled to interfaces
and therefore may pay a slight performance overhead**. However, you should
make this choice only if you know that the trait in question constitutes a
performance bottleneck and have evidence that using a class instead actually
solves the problem.
+ If you still do not know, after considering the above, then start by making
it as a trait. You can always change it later, and in general using a trait keeps
more options open.

# Case Class and Pattern Matching
## A simple example
~~~scala
abstract class Expr

case class Var(name: String) extends Expr
case class Number(name: Double) extends Expr
case class UnOp(operator: String, arg: Expr) extends Expr
case class BinOp(operator: String, left: Expr, right: Expr) extends Expr

val v = Var("x")                       // 1
val op = BinOp("+", Number(1), v)      // 1
v.name ;  op.left                      // 2
op.right == Var("x")  // true          // 3
op.copy(operator = "-")                // 4
~~~
The other noteworthy thing about the declarations of above is that each
subclass has a `case` modifier. Classes with such a modifier are called *case
classes*. Using the modifier makes the Scala compiler add some syntactic
conveniences to your class.

1. Adds a factory method with the name of the class.
2. All arguments in the parameter list of a case class implicitly get a `val`
prefix, so they are maintained as fields.
3. The compiler adds "natural" implementations of methods `toString`,
`hashCode` , and `equals` to your class.
4. The compiler adds a `copy` method to your class for making modified
copies.

**Pattern matching** 

~~~scala
def simplifyTop(expr: Expr): Expr = expr match {
  case UnOp("-", UnOp("-", e)) => e
  case BinOp("+", e, Number(0)) => e
  case BinOp("*", e, Number(1)) => e
  case _ => expr
}
~~~
**different from java `switch`**

1. `match` is an expression in Scala, i.e., it always results in a value.
2. Scala's alternative expressions never "fall through" into the next case.
3. If none of the patterns match, an exception named `MatchError` is thrown.

## Kinds of patterns
**Wildcard patterns**

~~~scala
expr match {
case BinOp(_, _, _) => println(expr +" is a binary operation")
case _ => println("It's something else")
}
~~~
**Constant patterns**

~~~scala
def describe(x: Any) = x match {
  case 5 => "five"
  case true => "truth"
  case "hello" => "hi!"
  case Nil => "the empty list"
  case _ => "something else"
}
~~~

**Variable patterns**   
**A variable pattern matches any object, just like a wildcard**. Unlike a wild-
card, Scala binds the variable to whatever the object is.

*Variable or contant?*

~~~scala
import math.{E, Pi}

E match {
  case Pi => "strange math? Pi = "+ Pi
  case _ => "OK"
}
// => OK

val pi = math.Pi
E match {
  case pi => "strange math? Pi = "+ pi
}
// strange math? Pi = 2.718281828459045   !!!!

E match {
  case pi => "strange math? Pi = "+ pi
  case _ => "OK"
}
output: 
warning: patterns after a variable pattern cannot match (SLS 8.1.1)
              case pi => "strange math? Pi = "+ pi
                   ^
<console>:12: warning: unreachable code due to variable pattern 'pi' on line 11
              case _ => "OK"
                        ^
<console>:12: warning: unreachable code
              case _ => "OK"

E match {
  case `pi` => "strange math? Pi = "+ pi
  case _ => "OK"
}
// OK
~~~

**Constructor patterns**    
A constructor pattern looks like `BinOp("+", e, Number(0))`   
These extra patterns mean that Scala patterns support *deep* matches.
Such patterns not only check the top-level object supplied, but also check
the contents of the object against further patterns.

~~~scala
expr match {
  case BinOp("+", e, Number(0)) => println("a deep match")
  case _ =>
}
~~~

**Sequence, Tuple, Typed patterns**    
You can match against sequence types like List or Array just like you match
against case classes. Use the same syntax, but now you can specify any
number of elements within the pattern.

~~~scala
expr match {
  case List(0, _, _)	=> println("found it")
  case 0::_				=> println("zero first list")  // List(0, _*)
  case _				=>
}

def tupleDemo(expr: Any) =
  expr match {
    case (a, b, c)  =>  println("matched "+ a + b + c)
    case _ =>
}

def generalSize(x: Any) = x match {
  case s: String		=> s.length
  case m: Map[_, _]		=> m.size
  case _				=> -1
}
~~~
Note that, even though `s` and `x` refer to the same value, the type of `x`
is `Any` , but the type of `s` is `String`.    
**But ...**

~~~scala
def isIntIntMap(x: Any) = x match {
  case m: Map[Int, Int] => true
  case _ => false
}
warning: non-variable type argument Int in type pattern
scala.collection.immutable.Map[Int,Int] (the underlying of Map[Int,Int]) is
unchecked since it is eliminated by erasure
       case m: Map[Int, Int] => true
               ^
isIntIntMap: (x: Any)Boolean
~~~
Scala uses the *erasure* model of generics, just like Java does. This means
that no information about type arguments is maintained at runtime.
Consequently, there is no way to determine at runtime whether a given `Map` object
has been created with two `Int` arguments, rather than with arguments of
different types.

The **only exception** to the erasure rule is arrays, because they are handled
specially in Java as well as in Scala. The element type of an array is stored
with the array value, so you can pattern match on it.

~~~scala
def isStringArray(x: Any) = x match {
  case a: Array[String] => "yes"
  case _ => "no"
}
~~~

**Variable binding**   
In addition to the standalone variable patterns, you can also add a variable
to any other pattern. You simply write the variable name, an at sign (@), and
then the pattern. This gives you a variable-binding pattern. The meaning of
such a pattern is to perform the pattern match as normal, and if the pattern
succeeds, **set the variable to the matched object just as with a simple variable
pattern**.

~~~scala
expr match {
  case UnOp("abs", e @ UnOp("abs", _)) => e
  case _ =>
}
~~~

## Pattern guards
~~~scala
def simplifyAdd(e: Expr) = e match {
  case BinOp("+", x, x) => BinOp("*", x, Number(2))
  case _ => e

  // pattern guard
  case BinOp("+", x, y) if x == y =>
    BinOp("*", x, Number(2))
}
error: x is already defined as value x
       case BinOp("+", x, x) => BinOp("*", x, Number(2))
~~~
This fails, because Scala restricts patterns to be linear: a pattern variable
may only appear once in a pattern. However, you can re-formulate the match
with a `pattern guard`.
## Pattern overlaps
~~~scala
def simplifyAll(expr: Expr): Expr = expr match {
  case UnOp("-", UnOp("-", e)) =>
    simplifyAll(e)
  case BinOp("+", e, Number(0)) =>
    simplifyAll(e)
  case BinOp("*", e, Number(1)) =>
    simplifyAll(e)
  case UnOp(op, e) =>
    UnOp(op, simplifyAll(e))
  case BinOp(op, l, r) =>
    BinOp(op, simplifyAll(l), simplifyAll(r))
  case _ => expr
}

def simplifyBad(expr: Expr): Expr = expr match {
  case UnOp(op, e) => UnOp(op, simplifyBad(e))
  case UnOp("-", UnOp("-", e)) => e
}
warning: unreachable code
       case UnOp("-", UnOp("-", e)) => e
~~~
## Sealed classes
Whenever you write a pattern match, you need to make sure you have cov-
ered all of the possible cases. Sometimes you can do this by adding a default
case at the end of the match, but that only applies if there is a sensible default
behavior. What do you do if there is no default? How can you ever feel safe
that you covered all the cases?    
The alternative is to make the superclass of your case classes `sealed`.
A sealed class cannot have any new subclasses added except the ones in the
same file.    
If you match against case classes
that inherit from a sealed class, the compiler will flag missing combinations
of patterns with a warning message.

~~~scala
sealed abstract class Expr

case class Var(name: String) extends Expr
case class Number(name: Double) extends Expr
case class UnOp(operator: String, arg: Expr) extends Expr
case class BinOp(operator: String, left: Expr, right: Expr) extends Expr
~~~
Now define a pattern match where some of the possible cases are left out:

~~~scala
def describe(e: Expr): String = e match {
  case Number(_) => "a number"
  case Var(_)    => "a variable"
}

warning: match may not be exhaustive.
It would fail on the following inputs: BinOp(_, _, _), UnOp(_, _)
       def describe(e: Expr): String = e match {
~~~
If we don't use `sealed`, the warning will not be reported.

~~~scala
def describe(e: Expr): String = e match {
  case Number(_) => "a number"
  case Var(_) => "a variable"
  case _ => throw new RuntimeException // Should not happen
}

def describe(e: Expr): String = (e: @unchecked) match {
  case Number(_) => "a number"
  case Var(_)    => "a variable"
}
~~~
## The `Option` type
Scala has a standard type named `Option` for optional values. Such a value
can be of two forms. It can be of the form `Some(x)` where `x` is the actual
value. Or it can be the `None` object, which represents **a missing value**.    
Optional values are produced by some of the standard operations on
Scala's collections. For instance, the get method of Scala's `Map` produces
`Some(value)` if a value corresponding to a given key has been found, or
`None` if the given key is not defined in the `Map`.   
The most common way to take optional values apart is through a pattern
match. For instance:

~~~scala
def show(x: Option[String]) = x match {
  case Some(s) => s
  case None => "?"
}
~~~
## Patterns everywhere
~~~scala
val myTuple = (123, "abc")
val (number, string) = myTuple

val exp = new BinOp("*", Number(5), Number(1))
val BinOp(op, left, right) = exp
~~~
**Case sequences as partial functions**

~~~scala
val withDefault: Option[Int] => Int = {
  case Some(x) => x
  case None => 0
}
withDefault(Some(10))
withDefault(None)

val second: List[Int] => Int = {
  case x :: y :: _ => y
}
warning: match may not be exhaustive.
It would fail on the following inputs: List(_), Nil
       val second: List[Int] => Int = {

// change to
val second: PartialFunction[List[Int],Int] = {
  case x :: y :: _ => y
}
second.isDefinedAt(List(5,6,7))  // true
second.isDefinedAt(List())       // false
// translated to 
new PartialFunction[List[Int], Int] {
  def apply(xs: List[Int]) = xs match {
    case x :: y :: _ => y
  }
  def isDefinedAt(xs: List[Int]) = xs match {
    case x :: y :: _ => true
    case _ => false
  }
}
~~~
**Patterns in `for` expressions**

~~~scala
for ((country, city) <- capitals)
  println("The capital of "+ country +" is "+ city)

val results = List(Some("apple"), None, Some("orange"))
for (Some(fruit) <- results) println(fruit)
apple
orange
~~~

**List Match**

~~~scala
def isort(xs: List[Int]): List[Int] = xs match {
  case List() => List()
  case x :: xs1 => insert(x, isort(xs1))
}
def insert(x: Int, xs: List[Int]): List[Int] = xs match {
  case List() => List(x)
  case y :: ys => if (x <= y) x :: xs
  else y :: insert(x, ys)
}
def append[T](xs: List[T], ys: List[T]): List[T] =
  xs match {
    case List() => ys
    case x :: xs1 => x :: append(xs1, ys)
  }
~~~




# Diff Languages
| Type | Scala functions | Ruby functions | Scheme functions |
| ---- | --------------- | -------------- | ---------------- |
| List | ::: | +, concat | append | 
| List | :: | unshift | cons |
| List | Nil | [] | (list) |
| List | (index) | [index] | (list-ref ls index) |
| List | drop(index) | [index..-1], drop | |
| List | dropRigth(index) | [0..(-1-index)] | |
| List | count(s => s.length == 4) | count{} | (count (lambda ..) ls) |
| List | exists(s => s.length == "until") | exists("until") | (exists (lambda ..) ls) |
| List | filter(s => s.length == 4) | select{} | (filter (lambda ..) ls) |
| List | flatten | flatten.compact | |
| List | forall(s => s.endsWith("l")): Boolean | all?{} | |
| List | foreach(s => print(s)) | each{} | (for-each (lambda ..) ls) |
| List | head | first | (first ls) |
| List | init | [0..-2] | |
| List | isEmpty | empty? | (null? ls) |
| List | last | last | |
| List | map(s => s + "y") | map{} | (map (lambda ..) ls) |
| List | mkString(",") | join | |
| List | remove(s => s.length = 4) | reject{} | |
| List | reverse | reverse | (reverse ls) |
| List | sort((s,t) => s.charAt(0).toLower < t.charAt(0).toLower | sort{} | (sort (lambda ..) ls) |
| List | tail | [1..-1] | (rest ls) |
| Array | ++ | +, concat | (append l1 l2) |
| Array | zip | zip | |

~~~scala
List(1,2,3).flatten
error: No implicit view available from Int => scala.collection.GenTraversableOnce[B].
              List(1,2,3).flatten
~~~
