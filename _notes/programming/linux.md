---
layout: document
title: Linux Note
---
## 1. Linux进程状态(ps stat)之R、S、D、T、Z、X

| R (TASK_RUNNING)                | 可执行状态                 |
| S (TASK_INTERRUPTIBLE)          | 可中断的睡眠状态           |
| D (TASK_UNINTERRUPTIBLE)        | 不可中断的睡眠状态         |
| T (TASK_STOPPED or TASK_TRACED) | 暂停状态或跟踪状态         |
| Z (TASK_DEAD – EXIT_ZOMBIE)     | 退出状态，进程成为僵尸进程 |
| X (TASK_DEAD – EXIT_DEAD)       | 退出状态，进程即将被销毁   |

## 2. nginx处理请求的有趣部分：(for php)
~~~
server {
  listen      80;
  server_name example.org www.example.org;
  root        /data/www;
  
  location / {
    index   index.html index.php;
  }
  
  location ~* \.(gif|jpg|png)$ {
    expires 30d;
  }
  
  location ~ \.php$ {
    fastcgi_pass  localhost:9000;
    fastcgi_param SCRIPT_FILENAME
                  $document_root$fastcgi_script_name;
    include       fastcgi_params;
  }
}
~~~
Handling a request “/” is more complex. It is matched by the prefix location “/” only, therefore, it is handled by this location. Then the index directive tests for the existence of index files according to its parameters and the “root /data/www” directive. If the file /data/www/index.html does not exist, and the file /data/www/index.php exists, then the directive does an internal redirect to “/index.php”, and nginx searches the locations again as if the request had been sent by a client. As we saw before, the redirected request will eventually be handled by the FastCGI server.    
[nginx request](http://nginx.org/en/docs/http/request_processing.html).  

## 3. nginx配置文件检测命令：
~~~
sudo $(which nginx) -t -c /etc/nginx/sites-available/cap3example_nginx.conf 
[sudo] password for donald: 
nginx: [emerg] "upstream" directive is not allowed here in /etc/nginx/sites-available/cap3example_nginx.conf:1
nginx: configuration file /etc/nginx/sites-available/cap3example_nginx.conf test failed
~~~