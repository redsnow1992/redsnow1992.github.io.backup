---
layout: document
title: Ruby Note
---

## 1. `require` VS `load`
When you `require` a Ruby file, the interpreter executes and caches it. If the file is required again (as in subsequent requests), the interpreter ignores the require statement and moves on. When you load a Ruby file, the interpreter executes the file again, no matter how many times it has been loaded before.

## 3.  Resources and Representations
A resource may be singular or plural, changeable (like the time of day) or fixed (like the text of The Little Prince). It’s basically a high-level description of the thing you’re trying to get hold of when you submit a request.What you actually do get hold of is never the resource itself, but a representation of it. A resource may, at any given point, be available in any number of representations (including zero). Thus your site might offer a text version of The Little Prince, but also an audio version. Those two versions would be understood as the same resource, and would be retrieved via the same identifier (URI). The difference in content type—one representation vs. another—would be negotiated separately in the request.  

## 4. `try`方法  
{% highlight ruby %}
def try(*a, &b)
  if a.empty? && block_given?
    yield self
  else
    public_send(*a, &b) if respond_to?(a.first)
  end
end
def try(*args)
  nil
end  
{% endhighlight %}

try 如果只接受 block 则传递 self 给 block，返回 block 执行后的结果，否则就执行
public_send，public_send 与 send 的不同之处，public_send 只会 call public_method，看例子      

    @person && @persion.name
    @person ? @person.name : nil

用 try 改写:  

    @person.try(:name)
    @person.try { |p| "#{p.first_name} #{p.last_name}" }   

try 同样能接受参数、block，  

    Person.try(:find, 1)
    @people.try(:collect) {|p| p.name}

## 5. ruby class, method
### 1. object's method, anonymous class
{% highlight ruby linenos %}
animal = 'cat'
def animal.speak
  puts "self is #{self}"
  puts "#{self.class}"
end
 #=> self is cat
 #=> String
'cat'.speak    #=> error
t = 'cat'
t.speak        #=> error
must be thus:
t = animal
t.speak     #=> right    #=> pass reference

class Test
  @var = 99
  def self.var
    @var
  end
  def self.var=(value)
    @var = value
  end
end
Test.var
Test.var=30
Test.new.var  #=> error
class Test
  attr_accessor :var
end
t = Test.new
t.var   #=> nil
t.var = 30
t.var   #=> 30
Test.var  #=> 99
class Test
  @var = 99
  class << self
    attr_accessor :var
  end
end
{% endhighlight %}

## ruby Fiber
~~~ruby
words = Fiber.new do
      File.foreach("testfile") do |line|
        line.scan(/\w+/) do |word|
          Fiber.yield word.downcase
        end
      end
      nil   # 结尾这个nil很重要，不然会返回File，会报`dead fiber called`错误
    end

    counts = Hash.new(0)
    while word = words.resume
      counts[word] += 1
    end
~~~
**同事的千分位分隔代码：** 

~~~ruby
def change_str(num)
  str = num.to_s
  nil while str.gsub!(/(.*\d)(\d\d\d)/, '\1,\2')
  return str
end
~~~
## core usage
### 1.Implementing Iterators
~~~ruby
def two_times
  yield
  yield
end

two_times { puts "hello"}

def fib_up_to(max)
  i1, i2 = 1, 1
  while i1 <= max
	  yield i1
	  i1, i2 = i2, i1 + i2
  end
end

class Array
  def find
	  each do |value|
		  return value if yield(value)
	  end
  end
end
[1, 2, 5, 7, 8].find{|v| v*v > 30} #=> 7
~~~

### 2. Enumerators--External Iterators
~~~ruby
['a', 'b', 'c'].each_with_index{|item, index| ... }
"cat".each_char.each_with_index{|item, index| ... } <=> "cat".each_char.with_index{ ... }
"cat".enum_for(:each_char)
(1..10).enum_for(:each_slice, 3).to_a => [[...], [...], [...], [10]]

*numerators Are Generators and Filters*
triangular_numbers = Enumerator.new do |yielder|
  number = 0
  count = 1
  loop do
	  number += count
	  count += 1
	  yielder.yield number
  end
end

p 5.times{print triangular_numbers.next, " " }
p triangular_numbers.first(5)

def infinit_select(enum, &block)
  Enumerator.new do |yielder|
	  enum.each do |value|
		  yielder.yield value if block.call(value)
	  end
  end
end
p infinit_select(triangular_numbers){|val| val % 10 == 0}.first(5) #=> [10, 120, 190, 210, 300]
class Enumerator
  def infinit_select(&block)
	  Enumerator.new do |yielder|
		  self.each do |value|
			  yielder.yield(value) if block.call(value)
		  end
	  end
  end
end
p triangular_numbers.infinit_select{}.infinit_select{}.first(5)

*Lazy Enumerator in Ruby 2*
def Integer.all
  Enumerator.new do |yielder, n: 0|
    loop {yielder.yield(n += 1)}
  end.lazy
end

p Integer.all.first(10)
p Integer.all.select{ ... }
multiple_of_three = Integer.all.select{|i| (i % 3).zero? }
multiple_of_three.select{|i| palindrome? i }
or:
multiple_of_three = -> n{(n%3).zero?}
palindrome = -> n{n = n.to_s n == n.reverse }
p Integer.all.select(&multiple_of_three).select(&palindrome).first(21)
~~~

### 3. block
~~~ruby
blocks for Transactions, eg: File.open
blocks can be objects
class ProcExample
  def pass_in_block(&action)
	  @stored_proc = action
  end
  def use_proc(param)
	  @stored_proc.call(param)
  end
end
eg = ProcExample.new
eg.pass_in_block {|param| puts "#{param}"}
eg.use_proc(3)

*return and blocks*
# A return from inside a raw block that's still in scope acts as a return from that scope. A return from a block
# whose original context is no longer valid raises an exception
def meth1
  (1..10).each do |val|
	  return val
  end
end
meth1.class #=> Fixnum ;  meth1 #=> 1
def meth2(&b)
  b
end
res = meth2 { return }
res.call #=> LocalJumpError

def meth3
  yield
end
t = Thread.new do 
  meth3 { return }
end
t.join #=> LocalJumpError, block is created in one thread and called in another

def meth4
  p = Proc.new { return 99 }
  p.call
  puts "Never get here"
end
meth4 #=> 4

A lambda behaves more like a free-standing method body: a return simply return from the block to the caller of the block
def meth5
  p = lambda { return 99 }
  res = p.call
  "The block returned #{res}"
end
meth5 #=> "... 99"
~~~

### 4. Composing Modules
~~~ruby
class VowelFinder
  include Enumerable
  def initialize(string)
	  @string = string
  end
  def each 
	  @string.scan(/[aeiou]/) do |vowel|
		  yield vowel
	  end
  end
end
VowelFinder.new("the quick brown fox jumped").inject(:+)
~~~

### 5. Instance variables in Mixins
~~~ruby
module Observable
  def observers
	  @observer_list ||= []
  end
  def add_observer(obj)
	  observers << obj
  end
  def notify_observers
	  observers.each {|o| o.update}
  end
end
class TelescopeScheduler
  include Observable
  def initialize
	  @observer_list = []   !!!!
  end
  def add_viewer(viewer)
	  @observer_list << viewer
  end
end
~~~

### 6. keyword Argument Lists
~~~ruby
def search(field, genre: nil, duration: 120)
# still pass in the hash, but ruby now matches the hash content to
  p [field, genre, duration]				# your keyword argument list
end
search(:title, duraton: 120) #=> unknown keyword: duration

# collect *extra hash arguments as a hash parameter*, just prefix one element with two '*'
def search(field, genre: nil, duration: 120, **rest) # cannot use one '*'
  p [field, genre, duration, rest]
end
search(:title, duration: 432, stars: 3, genre: "jazz", tempo: "slow")
#=> [:title, "jazz", 432, {:stars=>3, :tempo=>"slow"}]
~~~
