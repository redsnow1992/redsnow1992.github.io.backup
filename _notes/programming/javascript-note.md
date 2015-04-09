---
layout: document
title: Javascript Note
---
## 1. js judge Array
~~~javascript
var fruits = ["Banana", "Orange", "Apple", "Mango"];
document.getElementById("demo").innerHTML = isArray(fruits);

function isArray(myArray) {
  return Object.prototype.toString.call(myArray) 
    === "[object Array]";
}
~~~

## 2. JavaScript Closures
~~~javascript
var add = (function () {
var counter = 0;
    return function () {return counter += 1;}
})();

add();
add();
add();
// the counter is now 3
In fact, in JavaScript, all functions have access to the scope "above" them.
JavaScript supports nested functions. Nested functions have access to the scope "above" them. 
~~~

## 3. js operation on table
~~~javascript
function changeContent(id, row, cell, content) {
  var x = document.getElementById(id).rows[row].cells;
  x[cell].innerHTML = content;
}
function insertRow(id) {
  var x = document.getElementById(id).insertRow(0);
  var y = x.insertCell(0);
  var z = x.insertCell(1);
  y.innerHTML = z.innerHTML = "New";
} 
function deleteRow(id,row) {
  document.getElementById(id).deleteRow(row);
}
function createCaption(id) {
  document.getElementById(id).createCaption().innerHTML = "My new caption";
}
~~~

## 4. js eval
~~~javascript
function check(){
  var value = arguments[0] ;
  for(var i = 1 ; i < arguments.length ; i++){
	if (eval(eval(arguments[i])(value)) == false){
   	  return false ;
	}
  }
  return true ;
}
check(value, "non_empty", "number", "integer") ;
~~~
