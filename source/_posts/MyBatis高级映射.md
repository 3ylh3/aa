---
title: MyBatis高级映射
date: 2019-04-22 10:18:59
categories: 框架
tags: MyBatis
---
MyBatis高级映射用来处理复杂SQL的结果集和POJO的映射，接下来从两个方面来简单介绍一下MyBatis的高级映射。
#### 一对一映射
一对一映射使用的场景是联表查询是两个表中的记录是一对一的，考虑下面的例子：  
有一张订单表orders,表中有订单号order_no、顾客手机号mobile、订单金额amount以及订单日期date几个字段,其中订单号是主键；另外一张顾客表customer，有顾客手机号mobile和顾客姓名name两个字段，其中顾客手机号是主键。现在需要查询出一笔订单的信息以及对应顾客的姓名，因为一笔订单对应一名顾客，所以需要用到一对一映射。首先需要创建顾客和订单的POJO,注意Order中包含了一个Customer类型的成员变量：  
顾客：  
<!-- more -->
```java
package com.xiaobai.springbootmybatis.entity;

public class Customer {
    private String mobile;
    private String name;

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMobile() {
        return mobile;
    }

    public String getName() {
        return name;
    }
}
```
订单：  
```java
package com.xiaobai.springbootmybatis.entity;

public class Order {
    private String order_no;
    private String mobile;
    private String amount;
    private String date;
    private Customer customer;

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Customer getCustomer() {
        return customer;
    }

    public String getOrder_no() {
        return order_no;
    }

    public String getMobile() {
        return mobile;
    }

    public String getAmount() {
        return amount;
    }

    public String getDate() {
        return date;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
```
然后在MyBatis的mapper映射文件中配置resultMap:
```xml
<resultMap id="orderAndCustomer" type="com.xiaobai.springbootmybatis.entity.Order">
    <id property="order_no" column="order_no" />
    <result property="mobile" column="mobile" />
    <result property="amount" column="amount" />
    <result property="date" column="date" />
    <association property="customer" javaType="com.xiaobai.springbootmybatis.entity.Customer">
        <id property="mobile" column="mobile" />
        <result property="name" column="name" />
    </association>
</resultMap>
```
其中
```xml
<id property="order_no" column="order_no" />
```
是一个ID结果，标记出作为 ID的结果可以帮助提高整体性能。  
result是注入到POJO属性的普通结果，property对应着属性名，column对应结果集中的列名。  
association表示了是一对一映射。  
select标签如下：
```xml
<select id="queryOrderAndCustomer" resultMap="orderAndCustomer">
    select a.*,b.name from orders a,customer b where a.mobile = b.mobile and order_no = #{order_no}
</select>
```
这样MyBatis就会把最后的结果集映射到Order中。
#### 一对多映射
再考虑一张表订单明细表orderDetail，有订单号ord_no、明细序号detail_id、商品名goods以及商品加个money几个字段，其中明细序号是主键。一个订单可能包含多个商品，那么一笔订单号对应的在明细表中会有多条记录，现在除了查询订单信息以及顾客姓名外，还需要将订单明细查询出来，这样就用到了一对多映射。  
首先我们需要新建一个订单明细的POJO:
```java
package com.xiaobai.springbootmybatis.entity;

public class OrderDetail {
    private String order_no;
    private String goods;
    private String money;
    private String detail_id;

    public String getDetail_id() {
        return detail_id;
    }

    public void setDetail_id(String detail_id) {
        this.detail_id = detail_id;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }

    public void setGoods(String goods) {
        this.goods = goods;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public String getOrder_no() {
        return order_no;
    }

    public String getGoods() {
        return goods;
    }

    public String getMoney() {
        return money;
    }
}
```
然后在Order类中添加一个List<OrderDetail>类型的成员变量：
```java
package com.xiaobai.springbootmybatis.entity;

import java.util.List;

public class Order {
    private String order_no;
    private String mobile;
    private String amount;
    private String date;
    private Customer customer;
    private List<OrderDetail> detail;

    public List<OrderDetail> getDetail() {
        return detail;
    }

    public void setDetail(List<OrderDetail> detail) {
        this.detail = detail;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Customer getCustomer() {
        return customer;
    }

    public String getOrder_no() {
        return order_no;
    }

    public String getMobile() {
        return mobile;
    }

    public String getAmount() {
        return amount;
    }

    public String getDate() {
        return date;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
```
在映射文件中进行resultMap的配置：
```xml
<resultMap id="orderDetail" type="com.xiaobai.springbootmybatis.entity.Order">
    <id property="order_no" column="order_no" />
    <result property="mobile" column="mobile" />
    <result property="date" column="date" />
    <association property="customer" javaType="com.xiaobai.springbootmybatis.entity.Customer">
        <id property="mobile" column="mobile" />
        <result property="name" column="name" />
    </association>
    <collection property="detail" ofType="com.xiaobai.springbootmybatis.entity.OrderDetail">
        <id property="detail_id" column="detail_id" />
        <result property="goods" column="goods" />
        <result property="money" column="money" />
    </collection>
</resultMap>
```
collection表明是一对多映射，需要注意的是和一对一映射不同的是collection标签通过ofType来标注关联的POJO类型，而不是javaType。  
select标签如下：
```xml
<select id="queryOrderDetail" resultMap="orderDetail">
    select a.order_no,a.mobile,a.date,b.name,c.detail_id,c.goods,c.money
    from orders a,customer b,orderDetail c where a.mobile = b.mobile
    and a.order_no = c.order_no and a.order_no = #{order_no}
</select>
```