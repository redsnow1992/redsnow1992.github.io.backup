---
layout: document
title: Javascript Note
---
## 1. js judge Array
{% highlight javascript %}
var fruits = ["Banana", "Orange", "Apple", "Mango"];
document.getElementById("demo").innerHTML = isArray(fruits);

function isArray(myArray) {
  return Object.prototype.toString.call(myArray) 
    === "[object Array]";
}
{% endhighlight %}

## 2. JavaScript Closures
~~~
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
{% highlight javascript %}
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
{% endhighlight %}