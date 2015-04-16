---
layout: document
title: The Essentials of Programming Language
---
## 2.3 Interfaces for Recursive Data Types
~~~scheme
Lc-exp ::= Identifier
	   ::= (lambda (Identifier) Lc-exp)
	   ::= (Lc-exp Lc-exp)
~~~
Our interface will have **constructors** and two kinds of **observers**: **predicates** and **extractors**.    
The constructors are:

~~~scheme
var-exp      : Var → Lc-exp
lambda-exp   : Var × Lc-exp → Lc-exp
app-exp      : Lc-exp × Lc-exp → Lc-exp
~~~
The predicates are:

~~~scheme
var-exp?      : Lc-exp → Bool
lambda-exp?   : Lc-exp → Bool
app-exp?      : Lc-exp → Bool
~~~
The extractors are:

~~~scheme
var-exp->var            : Lc-exp → Var
lambda-exp->bound-var   : Lc-exp → Var
lambda-exp->body        : Lc-exp → Lc-exp
app-exp->rator          : Lc-exp → Lc-exp
app-exp->rand           : Lc-exp → Lc-exp
~~~
**Designing an interface**

1. Include one constructor for each kind of data in the data type.
2. Include one predicate for each kind of data in the data type.
3. Include one extractor for each piece of data passed to a constructor of the
data type.
