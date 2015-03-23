* Lists
** Conses
- cons :: always makes a single new cons cell, it appears to *add its first input onto the list that is its second input*.  \\
- list :: makes an entirely new cons cell chain. 
- circular list :: #1=(A B C . #1#)   \\ 
#1=(#1# . A) car of a cons cell points directlly back to itself.
#+BEGIN_SRC lisp
> (consp nil)
nil
> (listp nil)
T
#+END_SRC
** Equality
#+BEGIN_SRC lisp
> (eql (cons 'a nil) (cons 'a nil)
NIL
> (setf x (cons 'a nil))
(A)
> (eql x x)
T
> (equal x (cons 'a nil)) ;; return true if its arguments would print the same 
T 
#+END_SRC
** Building List
#+BEGIN_SRC lisp
> (setf x '(a b c)
        y (copy-list x))  ;; *copy-list* has same elements, but contained in new conses  
(A B C)
> (append '(a b) '(c d) '(e)) ;; *copy all the arguments except the last*
(A B C D E)
> (last '(a b c))  ;; return the last cons in a list 
(C)
#+END_SRC
** Example: Compress, [[run-length-encoding]]
** Access   
#+BEGIN_SRC common-list
> (nth 0 '(a b c))
A
> (nthcdr 2 '(a b c))
(C)
#+END_SRC
** Mapping Functions
#+BEGIN_SRC lisp
> (mapcar #'(lambda (x) (+ x 10))
	  '(1 2 3))
(11 12 13)
> (mapcar #'list '(a b c)
  	  '(1 2 3 4))
((A 1) (B 2) (C 3))
> (maplist #'(lambda (x) x) ;; call the function on successive cdrs of the lists.
	 '(a b c))
((A B C) (B C) (C)) 
#+END_SRC
** Trees
Conses can also be considered as binary tree, with the car representing the right subtree and the cdr the left.
#+BEGIN_SRC lisp
(defun our-copy-tree (tr)
  (if (atom tr)
      tr
      (cons (our-copy-tree (car tr))
	    (our-copy-tree (cdr tr)))))
> (subst 'y 'x '(and (integerp x) (zerop (mod x 2))))
(AND (INTEGERP Y) (ZEROP (MOD Y 2)))
#+END_SRC
** Sets
#+BEGIN_SRC lisp
> (member '(a) '((a) (z)) :test #'equal)
((A Z))
> (member 'c '((a b) (c d)) :key #'car)
((C D))
> (member-if #'oddp '(2 3 4))
(3 4)
> (adjoin 'b '(a b c))   ;; conses the object onto the list only if it is not already a member.
(A B C)
> (adjoin 'z '(a b c))
(Z A B C)  
#+END_SRC
~union~, ~set-difference~, ~intersection~, ~subsetp~, ~set-exclusive-or~ expect exactly *two lists*.
** Sequences
In Common Lisp, /sequences/ include both lists and vectors.
#+BEGIN_SRC lisp
> (subseq '(a b c d) 1 2)
(B)
> (subseq '(a b c d) 1)
(B C D)
> (sort '(0 2 1 3 8) #'>)
(8 3 2 1 0)

(defun nthmost (n lst)
  (nth (- n 1)
       (sort (copy-list lst) #'>)))
> (some #'oddp '(1 3 4))  ;; every
T
> (every #'> '(1 3 5) '(0 2 4))  ;; the predicate must take as many arguments as there are sequences,
T                                ;; and arguments are drawn one at a time from all the sequences.
#+END_SRC 
** Stacks
#+BEGIN_SRC lisp
> (setf x '(b))
(B)
> (push 'a x)
(A B)
> (setf y x)
(A B)
> (pop x)
A
> x
(B)
> y
(A B)
> (let ((x '(a b)))   ;; *pushnew* is a variant of push that uses *adjoin* instead of cons
    (pushnew 'c x)
    (pushnew 'a x)
    x)
(C A B)
#+END_SRC
** Assoc-lists
A list of conses is called an /assoc-list/ or /alist/
#+BEGIN_SRC lisp
> (setf trans '((+ . "add") (- . "subtract")))
((+ . "add") (- . "subtract"))
> (assoc '+ trans)
(+ . "add")
> (assoc '* trans)
NIL
> (assoc 7 '((6 . a) (9 . b)) :key #'1+)
(6 . A)
#+END_SRC

** Example: [[Shortest Path]]
------
* Specialized Data Structures
** Array
To make a 2x3 array: ~(setf arr (make-array '(2 3) :initial-element 3))~  \\
The same as ~#2a((3 3 3) (3 3 3))~
#+BEGIN_SRC lisp
> (aref arr 0 0)
NIL
> (setf (aref arr 0 0) 'b)
B
> (aref arr 0 0)
B
> (svref b 0)   ;; access 1-D array 
#+END_SRC
------
** String and Characters
#+BEGIN_SRC lisp
> (sort "elbow" #'char<)
"below"
> (aref "abc" 1)   ;; (char "abc" 1)
#\b
> (let ((str (copy-seq "Merlin")))
    (setf (char str 3) #\k)
    str)
"Merkin"
> (string-equal "fred" "Fred") ;; (equalp "fred" "Fred")
T
#+END_SRC
*building strings*
#+BEGIN_SRC lisp
> (format nil "~A or ~A" "truth" "dare")
"truth or dare"
> (concatenate 'string "not " "to worry")
"not to worry" 
#+END_SRC
** Sequences
includes both lists and vectors (and therefore strings) \\
reference element from sequence: ~(elt '(a b c) 1)~
#+ATTR_HTML: :border 2 :rules all :frame border
| parameter | purpose                             | default  |
|-----------+-------------------------------------+----------|
| :key      | a function to apply to each element | identity |
| :test     | the test function for comparision   | eql      |
| :from-end | if true, work backwards             | nil      |
| :start    | position at which to start          | 0        |
| :end      | position, if any, at which to stop  | nil      |

#+BEGIN_SRC lisp
> (position #\a "fantasia")
1
> (position #\a "fantasia" :start 3 :end 5)
4
> (position 'a '((c d) (a b)) :key #'car)
1 
> (position '(a b) '((a b) (c d)))
NIL
> (position '(a b) '((a b) (c d)) :test #'equal)  
0
> (position 3 '(1 0 7 5) :test #'<)
2
> (find #\a "cat")
#\a
> (find-if #'characterp "ham")
#\h
> (find-if #'(lambda (x)
	     (eql (car x) 'complete))
	 lst)
> (find 'complete lst :key #'car)   ;; better
> (remove-duplicates "abracadabra") ;; preserve only the last of each occrrence
"cdbra"
> (parse-integer "222")
222
3
#+END_SRC 
** Structures
#+BEGIN_SRC lisp
(defstruct point
  x
  y)
#+END_SRC
It also implicitly defines the function ~make-point~, ~point-p~, ~copy-point~, ~point-x~, ~point-y~  \\
Examples:
#+BEGIN_SRC lisp
> (setf p (make-point :x 0 :y 0))
#S(POINT :X 0 :Y 0)
> (point-x p)
0
> (setf (point-y p) 2)
2
> p
#S(POINT X 0 Y 2)
> (point-p p)
T
> (typep p 'point)
T
#+END_SRC
We can specify default values for structure fields by enclosing the field name and
a default expression in a list in the *original definition*.
#+BEGIN_EXAMPLE
(defstruct polemic
  (type (progn
	  (format t "What kind of polemic was it?")
	  (read)))
  (effect nil))

#+END_EXAMPLE
------
<2014-12-02 Tue>

**** run-length-encoding
#+BEGIN_SRC lisp
(defun compress (x)
  (if (consp x)
      (compr (car x) 1 (cdr x))
      x))

(defun compr (elt n lst)
  (if (null lst)
      (list (n-elts elt n))
      (let ((next (car lst)))
	(if (equal next elt)
	    (compr elt (+ n 1) (cdr lst))
	    (cons (n-elts elt n)
		  (compr next 1 (cdr lst)))))))

(defun n-elts (elt n)
  (if (> n 1)
      (list n elt)
      elt))

(defun uncompress (lst)
  (if (null lst)
      nil
      (let ((elt (car lst))
	    (rest (uncompress (cdr lst))))
	(if (consp elt)
	    (append (apply #'list-of elt)
		    rest)
	    (cons elt rest)))))

(defun list-of (n elt)
  (if (zerop n)
      nil
      (cons elt (list-of (- n 1) elt)))) 

;; (make-list n :initial-element elt)
#+END_SRC

**** Shortest Path
#+BEGIN_SRC lisp
(node . neighbors)
(setf *net* '((a b c) (b c) (c d)))

code from book (ansi_common_lisp):
(defun shortest-path (start end net)
  (bfs end (list (list start)) net))

(defun bfs (end queue net) ;; breath-first search
  (if (null queue)
      nil
      (let ((path (car queue)))
	(let ((node (car path)))
	  (if (eql node end)
	      (reverse path)
	      (bfs end
		   (append (cdr queue)
			   (new-paths path node net))
		   net))))))
(defun new-paths (path node net)
  (mapcar #'(lambda (n)
	      (cons n path))
	  (cdr (assoc node net))))
;; trace infos:
0: (SHORTEST-PATH A D ((A B C) (B C) (C D)))
  1: (BFS D ((A)) ((A B C) (B C) (C D)))
    2: (NEW-PATHS (A) A ((A B C) (B C) (C D)))
    2: NEW-PATHS returned ((B A) (C A))
    2: (BFS D ((B A) (C A)) ((A B C) (B C) (C D)))
      3: (NEW-PATHS (B A) B ((A B C) (B C) (C D)))
      3: NEW-PATHS returned ((C B A))
      3: (BFS D ((C A) (C B A)) ((A B C) (B C) (C D)))
	4: (NEW-PATHS (C A) C ((A B C) (B C) (C D)))
	4: NEW-PATHS returned ((D C A))
	4: (BFS D ((C B A) (D C A)) ((A B C) (B C) (C D)))
	  5: (NEW-PATHS (C B A) C ((A B C) (B C) (C D)))
	  5: NEW-PATHS returned ((D C B A))
	  5: (BFS D ((D C A) (D C B A)) ((A B C) (B C) (C D)))
	  5: BFS returned (A C D)
	4: BFS returned (A C D)
      3: BFS returned (A C D)
    2: BFS returned (A C D)
  1: BFS returned (A C D)
0: SHORTEST-PATH returned (A C D)
(A C D)

;; following is my implement:
(defun my-shortest-path (net start end)
  (shortest-path-core net (list start) end))

(defun my-shortest-path-core (net path end)
  (let ((start (first (last path))))
    (cond ((equal start end) path)
	  ((member end (assoc start net)) (append path (list end)))
	  ((null (assoc start net)) nil)
	  (t (select-min (mapcar #'(lambda (e)
				     (shortest-path-core net (append path (list e)) end))
				 (rest (assoc start net))))))))

(defun select-min (lst)
  "select min-length list from a list of lists"
  (first (sort lst #'(lambda (x y)
		       (< (length x) (length y))))))

#+END_SRC
     
