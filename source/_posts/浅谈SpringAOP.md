---
title: 浅谈SpringAOP
date: 2019-03-28 15:48:11
tags: Spring AOP
---
AOP是Aspect Oriented Programming的缩写，即面向切面编程。在一个系统中，有的功能是散布在应用的多处，跨了应用的多个点，这些功能被称为横切关注点，比如系统的日志记录。这些横切关注点在概念上独立于应用的业务逻辑，但通常它们会嵌入到应用的业务逻辑中，这样会造成两个问题：
1. 实现横切关注点功能的代码会重复出现在很多地方，如果需要改它的逻辑必须修改它嵌入的各个模块。即使把横切关注点作为一个独立的模块，但是对它的方法调用还是会重复的出现在每一个要嵌入的模块中；
2. 嵌入横切关注点的模块除了要关注自己本身的业务逻辑外，还要关注横切关注点要的功能，导致代码混乱。  

<!-- more -->
举个不太恰当的例子，把一个系统看作一个餐厅，每个来用餐的顾客是系统的一个独立模块，服务生可以看作一个横切关注点，他提供包括顾客用餐之前的迎接以及用餐之后的打扫餐桌。
顾客接口：
```java
public interface Guest{
    public void eat();
}
```
服务生类：
```java
public class Server {
    //迎接顾客
    public void greet(){
        System.out.println("The server is greeting the guest");
    }

    //打扫餐桌
    public void cleanTable(){
        System.out.println("The server is  cleaning the table");
    }
}
```
顾客实现类：
```java
public class Guest1 implements Guest {
    private Server server;
    public Guest1(Server server){
        this.server = server;
    }
    public void eat(){
        //服务生迎接顾客
        server.greet();
        //顾客用餐
        System.out.println("Guest1 is eating");
        //服务生打扫餐桌
        server.cleanTable();
    }
}
```
从这个例子可以很明显的看出来，服务生嵌入到了顾客中，但是理想的情况应该是顾客只需要关注自己的用餐就好，至于服务生迎接以及打扫的工作不是顾客需要关注的。AOP要解决的问题就是把这些横切关注点和业务逻辑分离。要了解AOP，首先要了解一些AOP的术语：
1. 连接点（Join point） 连接点是应用程序执行过程中能够插入切面（下面会讲）的一个点，Spring只支持方法级别的连接点。
2. 通知（Advice） 切面需要完成的工作被称为通知，通知定义了切面是什么以及何时使用。Spring切面有以下5种通知：
    - 前置通知（Before）:在目标方法被调用之前调用通知。
    - 后置通知（After）:在目标方法完成之后调用通知，不关心方法的输出。
    - 返回通知（After-returning）：在目标方法执行成功之后调用通知。
    - 异常通知（After-throwing） ： 在目标方法抛出异常后调用通知。
    - 环绕通知（Around） ： 包裹了目标方法， 在目标方法调用之前和调用之后执行自定义的行为。
3. 切点（ Poincut）：一个切面不需要通知所有的连接点，需要被通知的连接点即为切点，切点定义了切面在何处通知。
4. 切面（Aspect）:切面是通知和切点的结合，通知定义了切面是什么、何时使用，切点定义了在何处使用。
5. 引入（Introduction）：引入允许向现有类添加属性或方法。
6. 织入（ Weaving）：织入是把切面应用到目标对象的过程。Spring AOP是在运行期织入切面的。

Spring的切面由包裹了目标对象的代理类实现，代理类封装了目标类，拦截被通知方法的调用，执行相关切面逻辑后调用被通知方法。
现在再来看一下上面餐厅的例子，让我们用Spring AOP来把服务生作为切面独立出来。
修改后的顾客实现类：
```java
public class Guest1 implements Guest {
    public void eat(){
        System.out.println("Guest1 is eating");
    }
}
```
修改后的顾客实现类只有吃饭的逻辑，没有服务生的相关逻辑。
在配置文件中配置AOP：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd">

   <bean id="guest1" class="com.xiaobai.guest.Guest1"/>
   <bean id="server" class="com.xiaobai.server.Server"/>

   <aop:config>
      <aop:aspect ref="server">
         <aop:pointcut id="eat" expression="execution(* com.xiaobai.guest.Guest.eat(..))"/>
         <aop:before pointcut-ref="eat" method="greet"/>
         <aop:after pointcut-ref="eat" method="cleanTable" />
      </aop:aspect>
   </aop:config>
</beans>
```
其中guest1是顾客，server是服务生，aop:config是AOP的配置。aop:aspect声明了一个切面，指向服务生；aop:pointcut定义了一个切点，execution(* com.xiaobai.guest.Guest.eat(..))是切点表达式，execution代表匹配的连接点是方法，*代表任意的返回类型，表明不关心方法的返回值，com.xiaobai.guest.Guest.eat(..)是方法所属类的包名以及类名，..表明任意的方法入参；aop:before定义了一个前置通知，指向eat切点，执行的方法是greet;aop:after定义了一个后置通知，指向eat切点，执行的方法是cleanTable。配置完成后在主类中测试一下：
```java
public class MainApp {
    public static void main(String[] args) {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationConfig.xml");
        Guest guest1 = (Guest)ctx.getBean("guest1");
        guest1.eat();
    }
}
```
运行主类会看到：
```
The server is greeting the guest
Guest1 is eating
The server is  cleaning the table
```
这样服务生就和顾客的业务逻辑分离了。
让我们再添加一个顾客：
```java
public class Guest2 implements Guest {
    public void eat(){
        System.out.println("Guest2 is eating");
    }
}
```
配置文件中添加guest2的bean声明：
```xml
<bean id="guest2" class="com.xiaobai.guest.Guest2"/>
```
主类中增加guest2的调用：
```java
Guest guest1 = (Guest)ctx.getBean("guest1");
Guest guest2 = (Guest)ctx.getBean("guest2");
guest1.eat();
System.out.println();
guest2.eat();
```
运行后会看到：
```
The server is greeting the guest
Guest1 is eating
The server is  cleaning the table

The server is greeting the guest
Guest2 is eating
The server is  cleaning the table
```
可以看到不用顾客操心，服务生就会为每一位顾客服务。
现在假设我们的服务生不想为guest2服务了，有什么办法呢？使用bean()指示器在切点中选择相应的bean就可以了。修改配置文件中定义切点内容：
```xml
<aop:pointcut id="eat" expression="execution(* com.xiaobai.guest.Guest.eat(..)) and !bean(guest2)"/>
```
!bean(guest2)表示要切点匹配除了id为guest2的bean，再次运行程序会看到：
```
The server is greeting the guest
Guest1 is eating
The server is  cleaning the table

Guest2 is eating
```
服务生已经不再为guest2服务了。
再考虑一种情况，假设又来了一位顾客Guest3，他是个专业找茬的，总会说饭菜难吃，这时服务生会向顾客道歉，让我们修改一下server，给他添加一个道歉的方法：
```java
public void apologize(){
    System.out.println("The server is apologizing");
}
```
然后再自定义一个难吃的异常：
```java
public class UnpalatableException extends Exception {
    public String toString(){
        return "So unpalatable!";
    }
}
```
修改一下Guest接口：
```java
public interface Guest{
    public void eat() throws UnpalatableException;
}
```
新建一个顾客实现类Guest3,由它抛出异常：
```java
public class Guest3 implements Guest{
    public void eat() throws UnpalatableException{
        System.out.println("Guest3 is complaining");
        throw new UnpalatableException();
    }
}
```
在配置文件中添加guest3的定义：
```xml
<bean id="guest3" class="com.xiaobai.guest.Guest3"/>
```
在配置文件中新增一个异常通知：
```xml
<aop:config>
      <aop:aspect ref="server">
         <aop:pointcut id="eat" expression="execution(* com.xiaobai.guest.Guest.eat(..)) and !bean(guest2)"/>
         <aop:before pointcut-ref="eat" method="greet"/>
         <aop:after pointcut-ref="eat" method="cleanTable" />
         <aop:after-throwing pointcut-ref="eat" method="apologize"/>
      </aop:aspect>
   </aop:config>
```
在主类中测试一下：
```java
public class MainApp {
    public static void main(String[] args) {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationConfig.xml");
        Guest guest1 = (Guest)ctx.getBean("guest1");
        Guest guest2 = (Guest)ctx.getBean("guest2");
        Guest guest3 = (Guest)ctx.getBean("guest3");
        try {
            guest1.eat();
            System.out.println();
            guest2.eat();
            System.out.println();
            guest3.eat();
        }
        catch (UnpalatableException e){
            System.out.println(e.toString());
        }
    }
}
```
运行后会看到
```
The server is greeting the guest
Guest1 is eating
The server is  cleaning the table

Guest2 is eating

The server is greeting the guest
Guest3 is complaining
The server is  cleaning the table
The server is apologizing
So unpalatable!
```
我们看到server在guest3抛出异常后执行了 apologize方法。
再修改一下配置文件，把后置通知改为返回通知：
```xml
<aop:after-returning pointcut-ref="eat" method="cleanTable" />
```
重新运行一下，可以看到：
```
The server is greeting the guest
Guest1 is eating
The server is  cleaning the table

Guest2 is eating

The server is greeting the guest
Guest3 is complaining
The server is apologizing
So unpalatable!
```
server在guest3抛出异常后只执行了apologize方法。
接下来使用环绕通知重写一下服务生：
```java
public void server(ProceedingJoinPoint joinPoint){
        System.out.println("The server is greeting the guest");
        try{
            joinPoint.proceed();
            System.out.println("The server is  cleaning the table");
        }
        catch (Throwable e){
            System.out.println("The server is apologizing");
            System.out.println(e.toString());
        }
    }
```
服务生首先进行迎接客人，然后调用被通知的方法（joinPoint.proceed()），方法调用结束后进行打扫，如果方法抛出异常则进行道歉。
修改一下配置文件的内容，将前置通知、返回通知和异常通知改为一个环绕通知：
```xml
<aop:around pointcut-ref="eat" method="server"/>
```
重新运行后会看到：
```
The server is greeting the guest
Guest1 is eating
The server is  cleaning the table

Guest2 is eating

The server is greeting the guest
Guest3 is complaining
The server is apologizing
So unpalatable!
```
可以看到效果和前面的是一样的。
切面也可以访问被通知方法的参数，让我们修改一下Guest接口，添加一个pay方法：
```java
public void pay(int money);
```
实现类：
```java
public void pay(int money){
    System.out.println("Guest1 is paying " + money);
}
```
server添加receiveMoney方法:
```java
public void receiveMoney(int money){
    System.out.println("The server is receiving money " + money);
}
```
在配置文件中新增一个切面：
```xml
<aop:aspect ref="server">
   <aop:pointcut id="pay" expression="execution(* com.xiaobai.guest.Guest.pay(int)) and args(money)"/>
   <aop:after-returning pointcut-ref="pay" method="receiveMoney"/>
</aop:aspect>
```
其中int代表接受int类型的参数，args(money)指定了参数。
修改一下主类：
```java
public class MainApp {
    public static void main(String[] args) {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationConfig.xml");
        Guest guest1 = (Guest)ctx.getBean("guest1");
            guest1.eat();
            System.out.println();
            guest1.pay(100);
    }
}
```
运行后会看到：
```
The server is greeting the guest
Guest1 is eating
The server is  cleaning the table

Guest1 is paying 100
The server is receiving money 100
```
可以看到server访问到了pay方法的参数money。

完整代码已经上传到github：https://github.com/3ylh3/SpingAOPDemo  
参考资料：《Spring实战》
