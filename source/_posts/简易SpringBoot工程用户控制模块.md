---
title: 简易SpringBoot工程用户控制模块
date: 2019-04-24 16:28:30
categories: 框架
tags: Spring Boot
---
自己做了一个简易的Spring Boot工程的用户控制模块，基于Mybatis，提供Spring Boot工程的用户注册、登录、信息更新以及销户功能的支持。  
<!-- more -->
### 使用方法：  
 1. 引入编译好的jar包以及MyBatis的依赖。
 2. 在工程启动类上添加注解：
    ```java
    @MapperScan(UserControl.BASE_PACKAGE)
    ```
 3. 在工程配置文件(application.yml/properties)中配置用户表名以及表中用户名和密码字段的字段名，例子如下(以yml配置文件为例)：
    ```yml
    usercontrol:
      table: testTable
      username: testusername
      password: testpassword
    ```
 4. 调用相应API即可进行相关操作。

### API列表
#### 通用用户注册服务：RegisterService.register(String username,String password)。
参数：
 - username:需要注册用户的用户名。
 - password:需要注册用户的密码。
 
功能：
对username进行堵重判断，将记录插入对应用户表中。
返回码：
 - 0000:成功。
 - 0001:用户名重复。

#### 带额外字段的注册服务：RegisterService.register(String username,String password,Map<String,String>extralFields,Map<String,String>checkFields)
参数：
 - username:需要注册用户的用户名。
 - password:需要注册用户的密码。
 - extralFields:存储额外字段的Map,key为表中相应字段的字段名，value为要插入的字段值。
 - checkFields:存储需要进行堵重判断字段的Map,key为表中相应字段的字段名，value为要插入的字段值。

功能：
对username以及checkFields中的字段进行堵重判断，将记录插入对应用户表中。
返回码：
 - 0000:成功。
 - 0001:字段重复。

#### 用户登录服务：LoginService.login(String username,String password)
参数：
 - username:登录用户的用户名。
 - password:登录用户的密码。
功能:
对登录的用户进行存在性判断以及密码正确性校验。
返回码：
 - 0000:成功。
 - 0002:用户不存在。
 - 0003:密码错误。

#### 用户信息更新服务：UpdateService.update(String username,Map<String,String>fields)
参数：
 - username:待更新用户的用户名。
 - fields:存储待更新信息的Map,key为表中对应的字段名，value为需要更新的字段值。

返回码：
 - 0000:成功。
 - 0002:用户不存在。

#### 用户销户服务：DeleteService.delete(String username)
参数：
 - username:待销户用户名。

功能：
删除指定用户在表中的信息。
返回码：
 - 0000:成功。
 - 0002:用户不存在。

github地址：
https://github.com/3ylh3/usercontrol-springboot-starter