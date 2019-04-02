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
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/92d11aba740847222a735350b9df112d?fid=4047388677-250528-1101071544454066&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-356k2QWyvkrxrB%2foO8xtojUq8%2f8%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125752973211271004&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
选择Spring Initializr创建spring boot工程：
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/508eeaa8f87b54c65f941fa49a008c35?fid=4047388677-250528-439396504365999&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-1jxS66WOryb3YLgUzZoRJr4RSZA%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125769576267934607&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
选择Eureka Server:
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/a2654e03a59c341611a124e891d70a85?fid=4047388677-250528-993612707636519&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-ENFLcDRHldLrdRjuhFqyFEpmecg%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125784398452581592&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
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
```yml
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
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/bf3fe64d6500948897b1e8c12801e8c7?fid=4047388677-250528-722924595807630&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-Me5U27k2ZXUkuGR%2bZs5xHFjNodU%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125804163934456581&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
No instances available代表没有服务注册。
## 3.创建provider服务提供者模块
新建模块：
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/92d11aba740847222a735350b9df112d?fid=4047388677-250528-1101071544454066&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-356k2QWyvkrxrB%2foO8xtojUq8%2f8%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125804163934456581&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
选择Spring Initializr创建spring boot工程：
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/508eeaa8f87b54c65f941fa49a008c35?fid=4047388677-250528-439396504365999&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-1jxS66WOryb3YLgUzZoRJr4RSZA%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125804163934456581&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
选择web和Eureka Discovery创建eureka-client web工程：
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/94b36b69cfa87819f1a13b58075a17d3?fid=4047388677-250528-1037978541356091&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-3yf0dTw%2bIOnNBfUWWIf%2bQVYTwag%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125840562361037149&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/6384e65fa90b0ab1b1fc5e8d383e1ea5?fid=4047388677-250528-828431340802585&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-2epFu5KcnwJkpk3lNi4hSpig18Q%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125852767313399311&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
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
```yml
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
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/025ac5e7c15b52ca8d19f2b392e36534?fid=4047388677-250528-809129744794204&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-tyvYpeuwcSMdB%2fdteFN10Qbyric%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125879905141895915&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
## 3.创建consumer模块
新建模块：
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/92d11aba740847222a735350b9df112d?fid=4047388677-250528-1101071544454066&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-356k2QWyvkrxrB%2foO8xtojUq8%2f8%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125879905141895915&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
选择Spring Initializr创建spring boot工程：
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/508eeaa8f87b54c65f941fa49a008c35?fid=4047388677-250528-439396504365999&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-1jxS66WOryb3YLgUzZoRJr4RSZA%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125879905141895915&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
选择web、Eureka Discovery和Feign:
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/7ab04a2bf875b73e72fba0c62ccb1edc?fid=4047388677-250528-245330218961512&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-ddrLGkC1kdKufuDufH57L6g3xnQ%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125916616067154776&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/56af8e0b66e7b2a68a9cf3ca79cbcea6?fid=4047388677-250528-852570280490889&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-UvaGW1%2bKXVgXVJroTNqd%2b4bhuPM%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125927533832985341&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/48feebcb1299c5e7eaf4591a552ead91?fid=4047388677-250528-196908805402021&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-57x%2f1pmGWCkBoY8Ecp86%2fZULUek%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125941929578069780&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
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
```yml
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
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/3b8503d2ea95fa23d6a668dd95dd241f?fid=4047388677-250528-1099092014475157&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-kBPlarl%2bEJca7DYdGlSOqSrMRxY%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125971651777837688&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
此时访问http://localhost/sayHello就会看到调用成功：
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/c2505da31b19c07262cda096a31d1b05?fid=4047388677-250528-626931092251024&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-n63ARMmKED68pNXLtoe7lMSPimQ%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2125982752155201888&dp-callid=0&time=1554188400&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)

完整的项目代码已上传github:https://github.com/3ylh3/spring-cloud
