---
layout: document
title: Clojure Note
---
## defn, def, fn
{% highlight clojure %}
(defn square [x] (* x x))
(def square (fn [x] (* x x)))

vectors: [1,2,3,4]
maps: {:foo "bar" 3 4}
sets: #{1 2 3 4}
{% endhighlight %}