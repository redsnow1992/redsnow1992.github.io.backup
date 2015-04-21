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
for(arg <- args if !foundIt)
  if(!arg.startsWith("-"))
    if(arg.endsWith(".scala"))
      foundIt = true
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



