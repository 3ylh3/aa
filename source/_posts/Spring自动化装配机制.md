---
title: Spring自动化装配机制
date: 2019-04-09 15:16:12
categories: 框架
tags: Spring
---
Spring从两个方面实现了bean的自动化装配：
 - 组件扫描：通过组件扫描，Spring会自动发现应用上下文中所创建的bean。
 - 自动装配：Spring会自动满足bean之间的依赖。

先来讲一下组件扫描:  
<!-- more -->
#### 组件扫描
组件扫描是通过@Component注解实现的，来看一个bean的例子：   
```java
 package com.xiaobai.springdemo.bean;

import org.springframework.stereotype.Component;

@Component
public class TestBean {
    public void print(){
        System.out.println("This is a test bean.");
    }
}
```
这个bean和普通bean的区别就在于它加上了@Component注解，这个注解告诉Spring这个类会作为组件类，并且Spring需要为这个类创建bean。只有@Component注解是不行的，因为Spring默认没有开启组件扫描，需要在xml配置文件中加上：
```xml
<context:component-scan base-package="com.xiaobai.springdemo.bean"/>
```
这样就可以直接使用不用刚在配置文件中显示的声明bean了：
```java
public class MainApp {
    public static void main(String[] args) {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("auto.xml");
        TestBean bean = (TestBean)ctx.getBean("testBean");
        bean.print();
    }
}
```
运行结果：
```
This is a test bean.
```
在上面的例子中我们没有指定bean的id，Spring会根据它的类名指定一个默认的id：类名的第一个字母变成小写。我们也可以指定bean的id：@Component("xxx")。
再来看一下自动装配：
#### 自动装配
Spring的自动装配就是自动满足bean之间的依赖，通过@Autowired注解实现。@Autowired注解是通过byType模式实现自动注入的，即如果容器中存在一个和指定属性类型相同的bean，则将它注入，如果存在多个相同类型的则抛出异常，如果不存在同样也抛出异常（可以将@Autowired的required属性设置为false:@Autowired(required=false)来避免这个异常，设为false后如果没有匹配的bean,Spring会让这个bean处在未装配的状态，需要注意的是这样可能会造成NullPointerException）。来看下面的例子：
```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class TestBean2 {
    @Autowired
    private TestBean testBean;
    public void print2(){
        System.out.println("This is a test bean2.");
        testBean.print();
    }
}
```
可以看到这个bean中有一个TestBean类型的bean并且加上了@Autowired注解，这样就可以不用显示的在配置文件中声明两个bean的依赖关系了：
```java
public class MainApp {
    public static void main(String[] args) {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("auto.xml");
        TestBean2 bean = (TestBean2)ctx.getBean("testBean2");
        bean.print2();
    }
}
```
运行结果如下：
```
This is a test bean2.
This is a test bean.
```
@Autowired同样可以用在构造方法和setter方法上。