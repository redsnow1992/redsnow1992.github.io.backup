---
layout: document
title: Clojure Note
---
## defn, def, fn
~~~clojure
(defn square [x] (* x x))
(def square (fn [x] (* x x)))

vectors: [1,2,3,4]
maps: {:foo "bar" 3 4}
sets: #{1 2 3 4}
~~~

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



(range start? end step?)
(repeat n x)
(iterate f x)
(teke n seq)
(cycle coll)
(interleave & colls)
(interpost separator coll)
(join separator coll)
(list & elements)
(vector & elements)
(hash-set & elements)
(hash-map & elements)
(filter pred coll)
(take-while pred coll)
(drop-while pred coll)
(split-at index coll)
(split-with pred coll)
(every? pred coll)
(some pred coll)
(not-every? pred coll)
(not-any? pred coll)
(map f coll)
(reduce f coll)
(sort comp? coll)
(sort-by a-fn comp? coll)
(for [binding-form coll-expr filter-expr? ...] expr)

(defn whole-numbers [] (iterate inc 1))


Functions on Lists () 
(peek coll)    
(pop coll)

Functions on Vectors []
(peek vec)
(pop vec)
(get vec index) <==> (vec index)
(assoc vec index new-item)
(subvec avec start end?)

Functions on Maps {}
(keys map)
(vals map)
(get map key value-if-not found?)
(map key)
(keyword map)
(contains? map key)
(merge-with merge-fn & maps)

Functions on Set #{}
(union set1 set2)
(difference set1 set2)
(intersection set1 set2)
(select fn set)

letfn is like let but is dedicated to letting local functions.

One special case of recursion that can be optimized away on the JVM is a
self-recursion.

Use `recur-function` to call function.

~~~clojure
(defn tail-fibo [n]
  (letfn [(fib 
    [current next n]
    (if (zero? n)
      current
      (fib next (+ current next) (dec n))))]
  (fib 0N 1N n)))

(defn recur-fib [n]
  (letfn [(fib
    [current next n]
    (if (zero? n)
      current
      (recur next (+ current next) (dec n))))]
  (fib 0N 1N n)))

(defn lazy-seq-fibo
  ([]
    (concat [0 1] (lazy-seq-fibo 0N 1N)))
  ([a b]
    (let [n (+ a b)]
      (lazy-seq
        (cons n (lazy-seq-fibo b n))))))
~~~








