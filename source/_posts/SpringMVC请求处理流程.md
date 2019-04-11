---
title: SpringMVC请求处理流程
date: 2019-04-11 10:06:29
categories: 框架
tags:
 - Spring
 - SpringMVC
---
SpringMVC基于模型-视图-控制器模式（Model-View-Controller）实现，能够构建松散耦合的Web应用程序。
 - 模型：封装了需要返回给用户的数据，通常由POJO组成。
 - 视图：主要用于呈现模型数据。
 - 控制器：主要用来处理用户请求，并将合适模型传递给视图呈现。一个设计良好的控制器本身只做处理，将业务逻辑委托给具体的服务实现对象来做。
  
SpringMVC处理请求的主要流程如下图所示：
![SpringMVC请求处理流程](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringMVC%E8%AF%B7%E6%B1%82%E5%A4%84%E7%90%86%E6%B5%81%E7%A8%8B/SpringMVC.png)