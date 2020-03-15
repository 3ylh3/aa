---
title: Java动态代理
date: 2020-03-15 20:39:50
categories: Java
tags:
- 动态代理
---
代理是一种常用的设计模式，代理模式的定义是：代理模式的定义：为其他对象提供一种代理以控制对这个对象的访问。在某些情况下，一个对象不适合或者不能直接引用另一个对象，而代理对象可以在客户端和目标对象之间起到中介的作用。
<!-- more -->
Java动态代理底层基于反射机制，下面来看一个简单的例子：
首先来定义一个ADC接口，它有一个攻击的方法：
```java
/**
 * ADC接口
 */
interface ADC {
    void attack();
}
```
再定义一个卡莎类实现ADC接口：
```java
/**
 * 卡莎实现类
 */
class Kaisa implements ADC {
    @Override
    public void attack() {
        System.out.println("卡莎攻击敌人...");
    }
}
```
不同的玩家在使用卡莎的时候会选择不同的装备，我就习惯先出魔宗，接下来定义一个小白的调用处理实现类：
```java
/**
 * 小白调用处理实现类
 */
class XiaobaiInvocationHanlder implements InvocationHandler {
    private Object target;

    public XiaobaiInvocationHanlder(Object target) {
        this.target = target;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("卡莎购买魔宗");
        return method.invoke(target, args);
    }
}
```
其中target是要被代理的真实对象，invoke方法的三个参数分别是：
- proxy:代理后的对象
- method:被调用的方法
- args:调用时的参数

接下来来看一下测试代码：
```java
public class ProxyDemo {
    public static void main(String[] args) {
        Kaisa kaisa = new Kaisa();
        ADC xiaobai = (ADC) Proxy.newProxyInstance(kaisa.getClass().getClassLoader(), kaisa.getClass().getInterfaces(), new XiaobaiInvocationHanlder(kaisa));
        xiaobai.attack();
    }
}
```
输出结果为：
```
卡莎购买魔宗
卡莎攻击敌人...
```
分析一下代码可以看到首先创建了一个真实对象kaisa，然后调用Proxy的newProxyInstance方法为这个对象生成了一个代理对象xiaobai,这个对象其实是通过反射方式创建的，可以看一下newProxyInstance方法的代码：
```java
public static Object newProxyInstance(ClassLoader loader,
                                          Class<?>[] interfaces,
                                          InvocationHandler h)
        throws IllegalArgumentException
    {
        Objects.requireNonNull(h);

        final Class<?>[] intfs = interfaces.clone();
        final SecurityManager sm = System.getSecurityManager();
        if (sm != null) {
            checkProxyAccess(Reflection.getCallerClass(), loader, intfs);
        }

        /*
         * Look up or generate the designated proxy class.
         */
        Class<?> cl = getProxyClass0(loader, intfs);

        /*
         * Invoke its constructor with the designated invocation handler.
         */
        try {
            if (sm != null) {
                checkNewProxyPermission(Reflection.getCallerClass(), cl);
            }

            final Constructor<?> cons = cl.getConstructor(constructorParams);
            final InvocationHandler ih = h;
            if (!Modifier.isPublic(cl.getModifiers())) {
                AccessController.doPrivileged(new PrivilegedAction<Void>() {
                    public Void run() {
                        cons.setAccessible(true);
                        return null;
                    }
                });
            }
            return cons.newInstance(new Object[]{h});
        } catch (IllegalAccessException|InstantiationException e) {
            throw new InternalError(e.toString(), e);
        } catch (InvocationTargetException e) {
            Throwable t = e.getCause();
            if (t instanceof RuntimeException) {
                throw (RuntimeException) t;
            } else {
                throw new InternalError(t.toString(), t);
            }
        } catch (NoSuchMethodException e) {
            throw new InternalError(e.toString(), e);
        }
    }
```
可以看到是通过调用getProxyClass0（在getProxyClass0方法中，通过类加载器和入参传进去的接口（被代理的接口）生成了代理类的Class类）方法得到了代理对象的Class类，通过反射机制拿到构造函数，然后通过调用构造函数的newInstance方法并把入参的InvocationHandler传递进去生成了代理对象。最终生成的代理对象也实现了被代理的接口（例子中的ADC接口），在代理对象调用方法时，会调用InvocationHanlder的invoke方法（在例子中即xiaobai实现了ADC接口，在xiaobai的attack方法中调用了XiaobaiInvocationHanlder类的invoke方法）。
参考文章：
https://www.jianshu.com/p/95970b089360
https://blog.csdn.net/jiankunking/article/details/52143504