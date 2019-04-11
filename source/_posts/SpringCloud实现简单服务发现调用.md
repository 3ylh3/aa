---
title: SpringCloud实现简单服务发现调用
date: 2019-04-02 15:39:41
categories: 框架
tags:
  - Spring Cloud
---
使用eureka实现服务治理，使用feign实现远程调用。
具体实现如下：
## 1.创建空的maven项目
使用IDEA创建空的maven项目，创建完后删除src目录，修改pom文件内容如下：
<!-- more -->
```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <parent>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter-parent</artifactId>
          <version>2.1.3.RELEASE</version>
          <relativePath/> <!-- lookup parent from repository -->
       </parent>
       <groupId>com.xiaobai</groupId>
       <artifactId>spring-cloud</artifactId>
       <version>1.0-SNAPSHOT</version>
       <packaging>pom</packaging>

       <modules>
          <module>eureka-server</module>
          <module>provider</module>
          <module>consumer</module>
       </modules>


    </project>
```
## 2.创建eureka-server注册中心模块
新建模块：
![创建eureka-server注册中心模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228154453293.png)
选择Spring Initializr创建spring boot工程：
![创建eureka-server注册中心模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228151856361.png)
选择Eureka Server:
![创建eureka-server注册中心模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228152003238.png)
创建完成后修改pom文件parent节点为父项目的groupId、artifactId以及version，完整的pom文件如下：
```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <parent>
          <groupId>com.xiaobai</groupId>
          <artifactId>spring-cloud</artifactId>
          <version>1.0-SNAPSHOT</version>
       </parent>
       <groupId>com.xiaobai</groupId>
       <artifactId>eurekaserver</artifactId>
       <version>0.0.1-SNAPSHOT</version>
       <name>eurekaserver</name>
       <description>Demo project for Spring Boot</description>

       <properties>
          <java.version>1.8</java.version>
          <spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
       </properties>

       <dependencies>
          <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
          </dependency>

          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-test</artifactId>
             <scope>test</scope>
          </dependency>
       </dependencies>

       <dependencyManagement>
          <dependencies>
             <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
             </dependency>
          </dependencies>
       </dependencyManagement>

       <build>
          <plugins>
             <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
             </plugin>
          </plugins>
       </build>

       <repositories>
          <repository>
             <id>spring-milestones</id>
             <name>Spring Milestones</name>
             <url>https://repo.spring.io/milestone</url>
          </repository>
       </repositories>

    </project>
```

修改application.yml配置文件：
```yaml
    spring:
      application:
        name: eureka-server
    server:
      port: 8761
    eureka:
      instance:
        hostname: localhost
      client:
        registerWithEureka: false
        fetchRegistry: false
        serviceUrl:
          defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
```

其中registerWithEureka: false和fetchRegistry: false是关闭本服务的客户端行为，即不把本服务注册到注册中心。
给启动类添加@EnableEurekaServer注解：
```java
    package com.xiaobai.eurekaserver;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

    @SpringBootApplication
    @EnableEurekaServer
    public class EurekaserverApplication {

        public static void main(String[] args) {
            SpringApplication.run(EurekaserverApplication.class, args);
        }

    }
```
运行启动类，访问http://localhost:8761/会看到
![运行结果](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228154051813.png)
No instances available代表没有服务注册。
## 3.创建provider服务提供者模块
新建模块：
![创建provider服务提供者模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228154453293.png)
选择Spring Initializr创建spring boot工程：
![创建provider服务提供者模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228151856361.png)
选择web和Eureka Discovery创建eureka-client web工程：
![创建provider服务提供者模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228154617262.png)
![创建provider服务提供者模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/2019022815463168.png)
修改pom文件parent节点为父项目的groupId、artifactId以及version，完整的pom文件如下：
```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <parent>
          <groupId>com.xiaobai</groupId>
          <artifactId>spring-cloud</artifactId>
          <version>1.0-SNAPSHOT</version>
       </parent>
       <groupId>com.xiaobai</groupId>
       <artifactId>provider</artifactId>
       <version>0.0.1-SNAPSHOT</version>
       <name>provider</name>
       <description>Demo project for Spring Boot</description>

       <properties>
          <java.version>1.8</java.version>
          <spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
       </properties>

       <dependencies>
          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-web</artifactId>
          </dependency>
          <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
          </dependency>

          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-test</artifactId>
             <scope>test</scope>
          </dependency>
       </dependencies>

       <dependencyManagement>
          <dependencies>
             <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
             </dependency>
          </dependencies>
       </dependencyManagement>

       <build>
          <plugins>
             <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
             </plugin>
          </plugins>
       </build>

       <repositories>
          <repository>
             <id>spring-milestones</id>
             <name>Spring Milestones</name>
             <url>https://repo.spring.io/milestone</url>
          </repository>
       </repositories>

    </project>
```
修改application.yml配置文件：
```yaml
    spring:
      application:
        name: provider
    server:
      port: 8080
    eureka:
      client:
        serviceUrl:
          defaultZone: http://localhost:8761/eureka/
```
其中http://localhost:8761是eureka-server注册中心部署的ip和端口，由于我是在本地测试，所以就是localhost:8761。
给启动类加上@EnableEurekaClient注解:
```java
    package com.xiaobai.provider;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

    @SpringBootApplication
    @EnableEurekaClient
    public class ProviderApplication {

        public static void main(String[] args) {
            SpringApplication.run(ProviderApplication.class, args);
        }

    }
```
在com.xiaobai.provider.service下新建SayHelloService接口：
```java
    package com.xiaobai.provider.service;

    public interface SayHelloService {
        public String sayHello(String name);
    }
```
在com.xiaobai.provider.service.Impl下新建接口的实现类SayHelloImpl:
```java
    package com.xiaobai.provider.service.Impl;

    import com.xiaobai.provider.service.SayHelloService;
    import org.springframework.stereotype.Service;

    @Service
    public class SayHelloImpl implements SayHelloService {
        public String sayHello(String name){
            return "Hello " + name + "!";
        }
    }
```
在com.xiaobai.provider.controller下新建ProviderController:
```java
    package com.xiaobai.provider.controller;

    import com.xiaobai.provider.service.SayHelloService;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestParam;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    public class ProviderController {
        @Autowired
        private SayHelloService sayHelloService;
        @RequestMapping("/sayHello")
        public String sayHello(@RequestParam("name")String name){
            return sayHelloService.sayHello(name);
        }
    }
```
启动provider项目，刷新http://localhost:8761/页面查看provider服务注册成功：
![运行结果](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228165629403.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE0NzMwNjc=,size_16,color_FFFFFF,t_70)
## 3.创建consumer模块
新建模块：
![创建consumer模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228154453293.png)
选择Spring Initializr创建spring boot工程：
![创建consumer模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228151856361.png)
选择web、Eureka Discovery和Feign:
![创建consumer模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228165916502.png)
![创建consumer模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228170116134.png)
![创建consumer模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228165939578.png)
修改pom文件parent节点为父项目的groupId、artifactId以及version，完整的pom文件如下：
```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <parent>
          <groupId>com.xiaobai</groupId>
          <artifactId>spring-cloud</artifactId>
          <version>1.0-SNAPSHOT</version>
       </parent>
       <groupId>com.xiaobai</groupId>
       <artifactId>consumer</artifactId>
       <version>0.0.1-SNAPSHOT</version>
       <name>consumer</name>
       <description>Demo project for Spring Boot</description>

       <properties>
          <java.version>1.8</java.version>
          <spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
       </properties>

       <dependencies>
          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-web</artifactId>
          </dependency>
          <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
          </dependency>
          <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-openfeign</artifactId>
          </dependency>

          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-test</artifactId>
             <scope>test</scope>
          </dependency>
       </dependencies>

       <dependencyManagement>
          <dependencies>
             <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
             </dependency>
          </dependencies>
       </dependencyManagement>

       <build>
          <plugins>
             <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
             </plugin>
          </plugins>
       </build>

       <repositories>
          <repository>
             <id>spring-milestones</id>
             <name>Spring Milestones</name>
             <url>https://repo.spring.io/milestone</url>
          </repository>
       </repositories>

    </project>
```
修改application.yml配置文件，配置文件内容和provider类似，只需修改一下端口防止冲突：
```yaml
    spring:
      application:
        name: consumer
    server:
      port: 80
    eureka:
      client:
        serviceUrl:
          defaultZone: http://localhost:8761/eureka/
```
给启动类加上@EnableEurekaClient和@EnableFeignClients注解：
```java
    package com.xiaobai.consumer;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
    import org.springframework.cloud.openfeign.EnableFeignClients;

    @SpringBootApplication
    @EnableEurekaClient
    @EnableFeignClients
    public class ConsumerApplication {

        public static void main(String[] args) {
            SpringApplication.run(ConsumerApplication.class, args);
        }

    }
```
在com.xiaobai.consumer.service下新建SayHelloService接口：
```java
    package com.xiaobai.consumer.service;

    import org.springframework.cloud.openfeign.FeignClient;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestParam;

    @FeignClient(name = "provider")
    public interface SayHelloService {
        @RequestMapping("/sayHello")
        public String sayHello(@RequestParam("name")String name);
    }
```
其中 @FeignClient(name = "provider")注解中name是provider服务的服务名（ 配置文件配置的spring:application:name ）,@RequestMapping注解的值是在provider服务中ProviderController配置的映射。
在com.xiaobai.consumer.controller包下新建ConsumerController:
```java
    package com.xiaobai.consumer.controller;

    import com.xiaobai.consumer.service.SayHelloService;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    public class ConsumerController {
        @Autowired
        private SayHelloService sayHelloService;
        @RequestMapping("/sayHello")
        public String sayHello(){
            return sayHelloService.sayHello("xiaobai");
        }
    }
```
启动consumer服务，刷新http://localhost:8761/，看到consumer服务也注册成功：
![运行结果](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228172110143.png)
此时访问http://localhost/sayHello就会看到调用成功：
![运行结果](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloud%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E6%9C%8D%E5%8A%A1%E6%B3%A8%E5%86%8C%E5%8F%91%E7%8E%B0/20190228172218909.png)

完整的项目代码已上传github:https://github.com/3ylh3/spring-cloud
