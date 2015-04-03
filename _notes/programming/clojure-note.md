---
layout: document
title: Clojure Note
---
# Operation on collections and datastructures

## Collection
+ `conj` to add an item to a collection
+ `seq` to get a sequence of a collection
+ `count` to get the number of items of collection
+ `empty` to obtain an empty instance of the **same type** as a provided collection
+ `=` to determine value equality of a collection compared to one or more other collections 

`empty` allows you to work with collections of the same type as a given **instance**. Usually used in `(into (empty coll ..) ..)`

## Sequences
+ `seq` produces a sequence over its argument
+ `first`, `rest`, and `next` provide ways to consume sequences.
+ `lazy-seq` produces a *lazy sequence* that is the result of evaluating an expression. 

always true: 

~~~clojure
(= (next x)
   (seq (rest x)))
~~~

### Create seqs

`cons` accepts two arguments, a value ot serve as the head of the new seq, and another collection, the seq of which will serve as its tail:   
`(cons 0 (range 1 5))`
`list*` is just a helper for producing seqs with any number of head values, followed by a sequence. So, these two expression are equivalent:    
`(cons 0 (cons 1 (cons 2 (cons 3 (range 4 10)))))`       
`(list* 0 1 2 3 (range 4 10))`

### Lazy seqs

~~~clojure
(defn random-ints
   [limit]
   (lazy-seq
     (cons (rand-int limit)
	       (random-ints limit))))
~~~
Lazy sequences allow Clojure to transparently process big datasets that don't fit in memory and to express algorthms in a more uniform, declarative, pipelined way; in this contex, sequences can be considered *an ephemeral medium of computation*, not as colelections.

~~~clojure
(apply str (remove (set "aeiouy")
                   "vowels are useless! or may be not ..."))
~~~

**Head retention**      
Clojure's lazy sequences are persistent: an item is computed once, but is **still retained** by the sequence. This means that, as long as you maintain a reference to a sequence, you'll prevent its items from being garbage-collected, such can put pressure on the VM that will impact performance, potentially even causing an out of memory error if the realized portion of a sequence grows too large.

~~~clojure
(let [[t d] (split-with #(< % 12) (range 1e8))]
  [(count d) (count t)])
 ;; OutOfMemoryError GC overhead limit exceeded
 ;;   java.lang.Long.valueOf

;; solve the above problem
(let [[t d] (split-with #(< % 12) (range 1e8))]
  [(count t) (count d)])
~~~

## Associative
+ `assoc`, which establishes new associations between keys and values within the given collection
+ `dissoc`, which drops associations for given keys from collection
+ `get`, which looks up the value for a particular key in a collection
+ `contains`, which is a predicate that returns `true` only if the collection has a value associated with the given key.

**vectors associate values with indices**      
The **key** is everything, and the vector's key is index, not the seen value.     
**to find the value associated with a key we must use `find`**     

~~~clojure
(find {:ethel nil} :lucy)  ; => nil
(find {:ethel nil} :ethel) ; => [:ethel nil]

(if-let [[k v] (find {:a 5 :b 7} :a)]
  (format ...))
~~~

### Stack
Clojure doesn't have a distinct stack data structure, but is does support a stack abstraction via three operations:     
+ `conj`, for pushing a value onto the stack(conveniently reusing the collection-generalized operation)
+ `pop`, for obtaining the stack with its top value removed
+ `peek`, for obtaining the value on the top of the stack
Bothe lists and vectors can be used as stacks.

### Set
They are treated as a sort of degenerate map, **associating keys with themselves**.

### Sorted
+ `rseq`, which returns a seq of a collection's values in reverse, with the guarantee that doing so will return in constant time
+ `subseq`, which returns a seq of a collection's values that fall within a specified range of keys
+ `rsubseq` 

~~~clojure
(def sm (sorted-map :z 5 :x 9 :y 0 :b 2 :a 3 :c 4))
(rseq sm)
(subseq sm <= :c)
(subseq sm > :b <= :y)
(rsubseq sm > :b <= :y)
~~~

**sepcial**

~~~clojure
(defn magnitude
  [x]
  (-> x Math/log10 Math/floor))

(defn compare-magnitude
  [a b]
  (- (magnitude a) (magnitude b)))

(sorted-set-by compare-magnitude 10 1000 500)
;= #{10 500 1000}
(conj *1 600)
;= #{10 500 1000}
(disj *1 750)
;= #{10 1000}
(contains? *1 1239)
;= true
~~~
**change the implement of `compare-magnitude` can get different result**

~~~clojure
(defn compare-magnitude
  [a b]
  (let [diff (- (magnitude a) (magnitude b))]
    (if (zero? diff)
      (compare a b)
      diff)))
~~~
**Collections are function:** `([:a :b :c] 2)`     
**Collection key are (often) functions:** `(:b {:a 5 :b 6})`     

**Beware**   
`(remove #{5 7 false} (cons false (range 10)))`   
*change to:*   
`(remove (partial contains? #{5 7 false}) (cons false (range 10)))`

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

# Collections and Data Structures


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
;= d ;= ;= ;= ;=
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
A Clojure future evaluates a body of code in **another** thread:

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

## Clojure References Types
Identities are represented in Clojure using four reference types: `var`s, `ref`s, `agent`s, and `atom`s.              
All references always contain some value (even if that value is nil ); accessing one is
always done using deref or @.               
One critical guarantee of deref within the context of Clojure’s reference types is that
deref will never block, regardless of the change semantics of the reference type being
dereferenced or the operations being applied to it in other threads of execution.

all references types have `watches` and `validators`.

### Coordination
A `coordinated` operation is one where multiple actors **must cooperate**
(or, at a minimum, be properly sequestered so as to not interfere with each other) in
order to yield **correct** results.

In contrast, an `uncoordinated` operation is one where multiple actors **cannot impact**
each other negatively because their contexts are separated. For example, two different
threads of execution can safely write to two different files on disk with no possibility
of interfering with each other.

## Classifying Concurrent Operations
### Synchronization
`Synchronous` operations are those where the caller’s thread of
execution waits or blocks or sleeps until it may have exclusive access to a given context,
whereas `asynchronous` operations are those that can be started or scheduled without
blocking the initiating thread of execution.

|                  | coordinated | uncoordinated |
| ----             | ---:        | ---: |
| synchronization  | refs        | atoms |
| asynchronization |             | agents |

**A Demonstration Utility:**

~~~clojure
(defmacro futures [n & exprs]
  (vec (for [_ (range n)
             expr exprs]
         `(future ~expr))))

(defmacro wait-futures [& args]
  `(doseq [f# (futures ~@args)]
     @f#))
~~~
## Atoms
Operations that modify the state of atoms block until the modification is complete, and each modification is isolated, there is no way to orchestrate the modification of two atoms.     

~~~clojure
(def sarah (atom {:name "Sarah" :age 25 :wears-glasses? false}))
(swap! sarah update-in [:age] + 3)

clojure.core/swap!
([atom f] [atom f x] [atom f x y] [atom f x y & args])
  Atomically swaps the value of atom to be:
  (apply f current-value-of-atom args)
~~~
The behavior of swap! could be shown as following:

~~~clojure
(def xs (atom #{1 2 3}))
(wait-futures 1 (swap! xs (fn [v]
                            (Thread/sleep 250)
                            (println "trying 4")
                            (conj v 4)))
              (swap! xs (fn [v]
                          (Thread/sleep 500)
                          (println "trying 5")
                          (conj v 5))))

; trying 4
; trying 5
; trying 5
~~~
**totally set** the value of `atom` using `compare-and-set!`:     
`(compare-and-set! xs @xs "new value")`       
and a more **dangerous operation** `reset!`.

## Notifications and Constraints
### Watches
watchers used as logger.

~~~clojure
(def history (atom ()))
(defn log->list [dest-atom key source old new]
  (when (not= old new)
    (swap! dest-atom conj new)))
(def sarah (atom {:name "Sarah" :age 25}))

(add-watch sarah :record (partial log->list history))
~~~
### validator
~~~clojure
(def n (atom 1 :validator pos?))
(def sarah (atom {:name "Sarah" :age 25}))
(set-validator! sarah :age)
(set-validator! sarach #(or (:age %)
                            (throw (IllegalStateException. "People must have `:age`s!"))))

~~~

## Software Transactional Memory(STM)
In general terms, software transactional memory (STM) is any method of coordinating multiple concurrent modifications to a *shared set of storage locations*.










