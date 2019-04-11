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

<!-- more -->  
SpringMVC处理请求的主要流程如下图所示：  
![SpringMVC请求处理流程](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringMVC%E8%AF%B7%E6%B1%82%E5%A4%84%E7%90%86%E6%B5%81%E7%A8%8B/SpringMVC.png)  
请求首先到达的是DispatcherServlet，它是Spring的前端控制器，是一个单实例的servlet，它将请求委托给系统的其他组件来进行处理。请求到达DispatcherServlet后，它的任务是是把请求发给控制器，因为应用程序中存在多个控制器，所以DispatcherServlet要查询一个或多个处理器映射来确定到底要把请求发给哪个控制器，处理器映射会根据请求的URL来确定。确定了控制器后，DispatcherServlet会把请求发给相应的控制器，请求到达控制器后，控制器会调用相应的服务对象进行业务逻辑处理，处理完后服务对象会把生成的数据（模型）返回给控制器，控制器将模型数据打包，和逻辑视图名一起返回给DispatcherServlet。传递回来的视图名并不直接表示某个视图，DispatcherServlet会根据这个逻辑视图名去视图解析器匹配为一个特定的视图，然后将模型数据交付给视图，视图用模型数据来渲染输并响应。