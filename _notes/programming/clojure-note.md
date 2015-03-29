---
layout: document
title: Clojure Note
---
# Operation on collections and datastructures

~~~clojure
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

(defn whole-numbers [] 
	(iterate inc 1))


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
~~~

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

| Clojure                            | Ruby            |
| :----- | :----- |
| (not k)                            | not k or !k     |
| (inc a)                            | a += 1          |
| (/ (+ x y) 2)           					 | (x + y) /2      |
| (instance? java.util.List al)      | al.is_a? Array  |
| (if (not a) (inc b) (dec b))       | !a ? b+1 : b -1 |
| (Math/pow 2 10)                    | 2 ** 10         |
| (.someMethod someObj "foo" (.otherMethod otherObj 0)) | someObj.someMethod("foo", otherObj.otherMethod 0) |
| (assoc map key val & kvs) | merge |


Sequential destructuring(list, array, list)       

~~~clojure
(let [[x y & z] data]
  [x y z])

(let [[x _ z :as original-vector] v]
	(conj original-vector (+ x z)))
~~~

Map destructuring      

~~~clojure
    
(let [{a :a b :b} m] 
	(+ a b))

(let [{x 3 y 8} [12 0 0 -18 44 6 0 0 1]] 
	(+ x y))

(def map-in-vector ["James" {:birthday (java.util.Date. 73 1 6)}]) ;= #'user/map-in-vector
(let [[name {bd :birthday}] map-in-vector]
(str name " was born on " bd))

(let [{r1 :x r2 :y :as randoms}
	(zipmap [:x :y :z] 
		(repeatedly (partial rand-int 10)))]
	(assoc randoms :sum (+ r1 r2)))

(let [{k :unknown x :a :or {k 50}} m] ;; :or set default value
	(+ k x))

(let [{:keys [name age location]} chas]
	(format "%s is %s years old and lives in %s." name age location))

(letfn [(odd? [n]
	(even? (dec n)))
(even? [n]
	(or (zero? n)
		(odd? (dec n))))] (odd? 11))

(defn make-user
	[& [user-id]] 
	{:user-id (or user-id
		(str (java.util.UUID/randomUUID)))})

(defn make-user
	[username & {:keys [email join-date]
		:or {join-date (java.util.Date.)}}] 
		{:username username
			:join-date join-date
			:email email
			;; 2.592e9 -> one month in ms
			:exp-date (java.util.Date. (long (+ 2.592e9 (.getTime join-date))))})
~~~

|  Operation | Java code | Sugared intro form | Equivalent special form usage |
| :----| :--- | :--- | :--- |
| static method | Math.pow(2,10) | (Math/pow 2 10) | (. Math pow 2 10) |
| instance method invocation | "hello".substring(1,3) | (.substring "hello" 1 3) | (. "hello" substring 1 3) |
| Static field access | Integer_MAX_VALUE | Integer/MAX_VALUE | (. Integer MAX_VALUE) |
| instance field access | someObj.someField | (.someField someObj) | (. someObj someField) | 


~~~clojure
(reduce (fn [m v]
	(assoc m v (* v v)))
	{} [1 8 19])

(#(apply map * %&) [1 2 3] [4 5 6] [7 8 9])
;= (28 80 162)
(#(apply map * %&) [1 2 3])
;= (1 2 3)
((partial map *) [1 2 3] [4 5 6] [7 8 9])

(defn negated-sum-str
[& numbers]
(str (- (apply + numbers))))
;= #'user/negated-sum-str (negated-sum-str 10 12 3.4) ;= "-25.4"

(def negated-sum-str (comp str - +)) ;= #'user/negated-sum-str (negated-sum-str 10 12 3.4)
;= "-25.4"
~~~

Pure functions are cacheable and trivial to parallelize


# Concurrency and Parallelism
Shifting Computation Through Time and Space
## Delays
~~~clojure
(def d (delay (println "Running...") :done!))
;= #'user/d (deref d)
; Running... ;= :done!

@d
;= :done!    ;; cached
~~~
Delays only evaluate their body of code once, caching the return value. Thus, subsequent accesses using deref will return instantly, and not reevaluate that code.

A protential usage scenario  of Delay:      

~~~clojure
(defn get-document [id]
	; ... do some work to retrieve the identified document's metadata ... {:url "http://www.mozilla.org/about/manifesto.en.html"
	:title "The Mozilla Manifesto"
	:mime "text/html"
	:content (delay (slurp "http://www.mozilla.org/about/manifesto.en.html"))})
;= #'user/get-document
(def d (get-document "some-id"))
￼;= d ;= ;= ;= ;=
#'user/d
{:url "http://www.mozilla.org/about/manifesto.en.html", :title "The Mozilla Manifesto",
:mime "text/html",
:content #<Delay@2efb541d: :pending>}

(realized? (:content d))
;= false
@(:content d)
;= "<!DOCTYPE html><html>..." (realized? (:content d))
;= true
~~~

## Futures
A Clojure future evaluates a body of code in another thread:

~~~clojure
(def long-calculation (future (apply + (range 1e8))))

@long-calculation   <=> (deref long-calculation)
@(future (Thread/sleep 5000) :done!)  ;; block current thread
;; also has cache like `Delays'

;; **but we can set a timeout**
(deref (future (Thread/sleep 5000) :done!) 
	1000
	:impatient!)
~~~

## Promises

~~~clojure
(def p (promise))

(realized? p)
;= false
(deliver p 42)
;= #<core$promise$reify__1707@3f0ba812: 42> (realized? p)
;= true @p
;= 42
~~~
Thus, a promise is similar to a one-time, single-value pipe: data is inserted at one end via deliver and retrieved at the other end by deref. Such things are sometimes called dataflow variables and are the building blocks of declarative concurrency.

A simple example would involve three promises:

~~~clojure
(def a (promise)) 
(def b (promise)) 
(def c (promise))
~~~
We can specify how these promises are related by creating a future that uses (yet to be delivered) values from some of the promises in order to calculate the value to be delivered to another:

~~~clojure
(future
	(deliver c (+ @a @b))
	(println "Delivery complete!"))
~~~
In this case, the value of c will not be delivered until both a and b are available (i.e., **realized?**); until that time, the future that will deliver the value to c will block on dereferencing a and b.

Promises don’t detect cyclic dependencies
This means that `(deliver p @p)`, where p is a promise, will block indefinitely.        
However, such blocked promises are not locked down, and the situation can be resolved:

~~~clojure
(def a (promise)) 
(def b (promise))
(future (deliver a @b)) 
(future (deliver b @a))
(realized? a) 
;= false (realized? b) ;= false
(deliver a 42)
;= #<core$promise$reify__5727@6156f1b0: 42>
@a
;= 42 
@b
;= 42
~~~
Make callback-based APIs synchronous
~~~clojure
((sync-fn call-service) 8 7)

((sync-fn call-service) 8 7)

(defn sync-fn [async-fn]
  (fn [& args]
    (let [result (promise)]
      (apply sync-fn (conj (vec args) #(deliver result &%))))
    @result))


(defn call-service [arg1 arg2 callback-fn]
  (future (callback-fn (+ arg1 arg2) (- arg1 arg2))))
~~~
# Parallelism on the Cheap
~~~clojure
(defn phone-numbers [string]
  (re-seq #"(\d{3})[\.-]?(\d{3})[\.-]?(\d{4})" string))

(def files (repeat 100
  (apply str
    (concat (repeat 1000000 \space)
      "Sunil: 617.555.2937, Betty: 508.555.2218"))))

(time (dorun (map phone-numbers files)))  ;; "Elapsed time: 2236.505069 msecs"
(time (dorun (pmap phone-numbers files)))  ;; "Elapsed time: 1028.172429 msecs"

(def files (repeat 100000 (apply str
  (concat (repeat 10 \space)
    "Sunil: 617.555.2937, Betty: 508.555.2218"))))

;; "Elapsed time: 154.914828 msecs"
;; "Elapsed time: 276.043889 msecs"
~~~
There is often a workaround for such scenarios, however. You can often efficiently parallelize a relatively trivial operation by chunking your dataset so that each unit of parallelized work is larger. In the above example, the unit of work is just 1K of text; however, we can take steps to ensure that the unit of work is larger, so that each value processed by pmap is a seq of 250 1K strings, thus boosting the work done per future dispatch and cutting down on the parallelization overhead:

~~~clojure
(time (->> files 
  (partition-all 250)
  (pmap (fn [chunk] (doall (map phone-numbers chunk)))) 
  (apply concat)
  dorun))
;; "Elapsed time: 114.678729 msecs"
~~~

























