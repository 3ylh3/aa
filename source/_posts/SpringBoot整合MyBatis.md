---
title: SpringBoot整合MyBatis
date: 2019-04-15 15:18:17
categories: 框架
tags:
 - Spring Boot
 - MyBaits
---
MyBatis是一款优秀的持久层框架，它消除了JDBC的重复冗余的代码，可以通过xml文件或者注解配置（注解配置能力有限，如果是复杂的SQL语句最好使用xml配置）来把普通类型或者是POJO映射成数据库中的记录。在Spring Boot项目中使用MyBatis非常简单，只需要在pom文件中添加MyBatis以及相应JDBC驱动的依赖（Maven项目）即可(这只是最基本的使用，还可以使用DBCP2等数据库连接池)：
<!-- more -->
```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter<artifactId>
    <version>2.0.1</version>
</dependency>

<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
</dependency>
```
然后在application.yml配置文件中添加相应配置：
```yaml
spring:
  datasource:
    #数据库用户名
    username: xxx
    #数据库密码
    password: xxx
    #url
    url: jdbc:mysql://xx.xx.xx.xx:3306/xxx
    driver-class-name: com.mysql.cj.jdbc.Driver
mybatis:
  #dao接口所在的包
  type-aliases-package: com.xiaobai.springbootmybatis.dao
  #mapper映射文件的路径
  mapper-locations: classpath:mapper/*.xml
```
在启动类上添加@MapperScan注解,值是dao接口所在的包：
```java
package com.xiaobai.springbootmybatis;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.xiaobai.springbootmybatis.dao")
public class SpringbootmybatisApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringbootmybatisApplication.class, args);
    }

}
```
在数据库中新建测试表：
```sql
create table testTable
(
	id varchar(10) not null,
	name varchar(100) null,
	constraint testTable_pk
		primary key (id)
);
```
然后插入两条数据：
```sql
insert into testTable (id,name) values ('1','Tom');
insert into testTable (id,name) values ('2','Jerry');
commit;
```
准备好测试表后在项目com.xiaobai.springbootmybatis.entity包下新建entity对象：
```java
package com.xiaobai.springbootmybatis.entity;

public class User {
    private String id;
    private String name;

    public void setName(String name) {
        this.name = name;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }
}
```
在com.xiaobai.springbootmybatis.dao包下新建dao接口：
```java
package com.xiaobai.springbootmybatis.dao;

import com.xiaobai.springbootmybatis.entity.User;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UserMapper {
    public User queryUserById(@Param("id") String id);
}
```
@Repository注解表示这是一个持久层dao接口。
在项目resources目录下新建mapper/UserMapper.xml:
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
   PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
   "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.xiaobai.springbootmybatis.dao.UserMapper">
   <select id="queryUserById" resultType="com.xiaobai.springbootmybatis.entity.User">
      select id,name from testTable where id = #{id}
   </select>
</mapper>
```
需要注意的是namespace的值需要和dao接口的完整名称对应，select中id的值需要和dao接口中某个方法名对应。
在com.xiaobai.springbootmybatis.service包下新建一个service接口：
```java
package com.xiaobai.springbootmybatis.service;

import com.xiaobai.springbootmybatis.entity.User;

public interface UserService {
    public User queryUserById(String id);
}
```
在com.xiaobai.springbootmybatis.service.Impl包下新建接口的实现类：
```java
package com.xiaobai.springbootmybatis.service.Impl;

import com.xiaobai.springbootmybatis.dao.UserMapper;
import com.xiaobai.springbootmybatis.entity.User;
import com.xiaobai.springbootmybatis.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public User queryUserById(String id) {
        return userMapper.queryUserById(id);
    }
}
```
在com.xiaobai.springbootmybatis.controller包下新建一个controller：
```java
package com.xiaobai.springbootmybatis.controller;

import com.xiaobai.springbootmybatis.entity.User;
import com.xiaobai.springbootmybatis.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class QueryUserController {
    @Autowired
    private UserService userService;
    @RequestMapping(value = "/query",method = RequestMethod.GET)
    public User queryUserByUsername(@RequestParam("id")String username){
        User user = userService.queryUserById(username);
        return user;
    }
}
```
启动项目，访问http://localhost:8080/query?id=1
会看到：
```
{"id":"1","name":"Tom"}
```
让我们来看一下UserMapper.xml文件，这个文件是MyBatis的xml映射文件，里面有一个最简单的select:
```xml
<select id="queryUserById" resultType="com.xiaobai.springbootmybatis.entity.User">
    select id,name from testTable where id = #{id}
</select>
```
接收一个String类型的参数（省略了parameterType="java.lang.String"）,返回一个User对象。注意参数符号#{id},它和${id}的区别在于#{}会会导致MyBatis创建 PreparedStatement参数占位符并安全地设置参数，防止SQL注入，举个例子，如果select元素这样写：
```xml
<select id="queryUserById" resultType="com.xiaobai.springbootmybatis.entity.User">
    select id,name from testTable where id = '${id}'
</select>
```
假如传入的参数是1，那么最后的SQL就是
```sql
select id,name from testTable where id = '1'
```
这样做会有被SQL注入的风险，如果传入的参数是1' or '1' = '1,那么最后的SQL会变成：
```sql
select id,name from testTable where id = '1' or '1' = '1'
```
这是很危险的，而使用#{}可以避免这个问题，因此尽量使用#{}，但是有些情况想直接在SQL语句中插入一个不转义的字符串时必须使用${}的，比如：
```sql
order by ${id}
```
如果使用#{id}，参数传id的话的最后会变成：
```sql
order by 'id'
```
显然达不到目的。