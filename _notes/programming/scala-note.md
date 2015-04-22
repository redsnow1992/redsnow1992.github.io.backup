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
class Rectangle(val topLeft: Point, val bottomRight: Point) extends {
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
## Traits as statckable modifications






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

