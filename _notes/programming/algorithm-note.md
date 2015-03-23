---
layout: document
title: Algorithm Note
---
## 1. 仅包含两种字母的最长子串
{% highlight ruby linenos %}
def my_get_substr(target)
  puts "target string is #{target}"
  if target.length <= 2
    return target
  end

  current_substr = target[0..1]
  max_substr = []

  target[2..-1].each_char do |char|
    if current_substr.include?(char)
      current_substr << char
    else
      max_substr << current_substr
      index = current_substr =~ /#{current_substr[-1]}{1,}$/
      current_substr = current_substr[index..-1] + char
    end
  end
  max_substr << current_substr
  max_length = max_substr.sort_by(&:length)[-1].length
  max_substr = max_substr.select{|s| s.length >= max_length}
end
{% endhighlight %}