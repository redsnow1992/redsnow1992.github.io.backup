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

(concat [1 2] [12 5])
(class (/ 22 7))
  clojure.lang.Ratio

(.toUpperCase "hello")
(Character/toUpperCase \t)
\T

(apply str (interleave "Attack at midnight" "The purple elephant chortled"))

The call to (take-nth 2 ...) takes every second element of the sequence, extracting
the obfuscated message

true? false? nil? zero?
string? keyword? symbol?

#{} => Set
{}  => Hash

(get the-map key not-found-val?)


If several maps have keys in common, you can document (and enforce) this
fact by creating a record with defrecord :
(defrecord name [arguments])

(def b (->Book "Anathem" "Neal Stephenson"))
(fn [params*] body)
#(body) %1(%),%2,%3

destructure parameters

(defn greet-author-2 [{fname :first-name}]
  (println "hello, " fname))
(let [[x y :as coords] [1 2 3 4 5 6]]
  (str "x: " x ", y" y ", total " (count coords)))
 => "x: 1, y2, total 6"