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