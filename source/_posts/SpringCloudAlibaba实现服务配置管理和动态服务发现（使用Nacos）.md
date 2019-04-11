---
title: SpringCloudAlibaba实现服务配置管理和动态服务发现（使用Nacos）
date: 2019-04-02 14:59:15
categories: 框架
tags:
  - Spring Cloud
  - Nacos
---
2018年10月31日，Spring Cloud 发布了 Spring Cloud Alibaba的首个版本，它是由一些阿里巴巴的开源组件和云产品组成的,主要功能有（官方介绍）：

 - **服务限流降级**：默认支持 Servlet、Feign、RestTemplate、Dubbo 和 RocketMQ 限流降级功能的接入，可以在运行时通过控制台实时修改限流降级规则，还支持查看限流降级 Metrics 监控。
 - **服务注册与发现**：适配 Spring Cloud 服务注册与发现标准，默认集成了 Ribbon 的支持。
 - **分布式配置管理**：支持分布式系统中的外部化配置，配置更改时自动刷新。
 - **消息驱动能力**：基于 Spring Cloud Stream 为微服务应用构建消息驱动能力。
 - **分布式事务**：使用 @GlobalTransactional 注解， 高效并且对业务零侵入地解决分布式事务问题。
 - **阿里云对象存储**：阿里云提供的海量、安全、低成本、高可靠的云存储服务。支持在任何应用、任何时间、任何地点存储和访问任意类型的数据。
 - **分布式任务调度**：提供秒级、精准、高可靠、高可用的定时（基于 Cron 表达式）任务调度服务。同时提供分布式的任务执行模型，如网格任务。网格任务支持海量子任务均匀分配到所有 Worker（schedulerx-client）上执行。
 - **阿里云短信服务**：覆盖全球的短信服务，友好、高效、智能的互联化通讯能力，帮助企业迅速搭建客户触达通道。  
本文分两部分来介绍通过Nacos实现配置管理和动态服务发现。
<!-- more -->
## 一、配置管理
### 1.安装Naocs(Linux环境)
首先下载Nacos压缩包：https://github.com/alibaba/nacos/releases ,下载后使用tar命令解压，进入bin目录，运行下面命令启动：
```
    sh startup.sh -m standalone
```
然后访问http:/x.x.x.x:8848/nacos/index.html(x.x.x.x为安装服务器)，输入用户名密码（默认都是nacos），登录后看到：
![nacos](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190304174812185.png)
至此Nacos安装成功。

### 2. 实现动态配置管理
首先在Nacos新增配置，点击+号：
![nacos](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190304175048811.png)
填写Data Id、Group和内容，配置格式选择YAML。
![nacos](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190304175143790.png)
其中Data Id的完整格式为：
```
    ${prefix}-${spring.profile.active}.${file-extension}
```
prefix 默认为 spring.application.name 的值，也可以通过配置项 spring.cloud.nacos.config.prefix来配置。
spring.profile.active 即为当前环境对应的 profile，注意：当 spring.profile.active 为空时，对应的连接符 - 也将不存在，dataId 的拼接格式变成 `${prefix}.${file-extension}`
file-exetension 为配置内容的数据格式，可以通过配置项 spring.cloud.nacos.config.file-extension 来配置。目前只支持 properties 和 yaml 类型。
配置完成后使用IDEA新建空的maven项目，创建完后删除src目录，修改pom文件内容如下：
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
       <artifactId>spring-cloud-alibaba-demo</artifactId>
       <version>1.0-SNAPSHOT</version>
       <packaging>pom</packaging>

       <modules>
          <module>config-client</module>
          <module>service-discovery</module>
       </modules>

    </project>
```
新建config-client模块，选择Spring Initializr创建Spring Boot工程，依赖选择：
![新建config-client模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190304180745749.png)
创建完成后修改pom文件parent节点并添加依赖：
```xml
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
        <version>0.2.1.RELEASE</version>
    </dependency>
```
完整pom文件如下：
```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <parent>
          <groupId>com.xiaobai</groupId>
          <artifactId>spring-cloud-alibaba-demo</artifactId>
          <version>1.0-SNAPSHOT</version>
       </parent>
       <groupId>com.xiaobai</groupId>
       <artifactId>config-client</artifactId>
       <version>0.0.1-SNAPSHOT</version>
       <name>config-client</name>
       <description>Demo project for Spring Boot</description>

       <properties>
          <java.version>1.8</java.version>
          <spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
       </properties>

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

       <dependencies>
          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-web</artifactId>
          </dependency>

          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-test</artifactId>
             <scope>test</scope>
          </dependency>

          <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
             <version>0.2.1.RELEASE</version>
          </dependency>

       </dependencies>

       <build>
          <plugins>
             <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
             </plugin>
          </plugins>
       </build>

    </project>
```
修改配置文件名称为bootstrap.yml(或bootstrap.properties，需要注意要获取Nacos配置的属性必须使用bootstrap)，修改内容为：
```yaml
    server:
      port: 8880
    spring:
      application:
        name: config-client
      cloud:
        nacos:
          config:
            server-addr: x.x.x.x:8848
            group: xiaobai
            file-extension: yml
```
其中spring.application.name以及file-extension需要和配置的Data Id中对应（config-client.yml），group需要和配置的Group对应(xiaobai)，server-addr是Nacos的安装地址。
给启动类添加@RefreshScope注解实现配置自动更新:
```java
    package com.xiaobai.configclient;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.cloud.context.config.annotation.RefreshScope;

    @SpringBootApplication
    @RefreshScope
    public class ConfigClientApplication {

        public static void main(String[] args) {
            SpringApplication.run(ConfigClientApplication.class, args);
        }

    }
```
在con.xiaobai.configclient.controller下编写ConfigController:
```java
    package com.xiaobai.configclient.controller;

    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    public class ConfigController {
        @Value("${message}")
        private String message;
        @RequestMapping("/config")
        public String config(){
            return message;
        }
    }
```
使用@Value注解来获取配置文件中的message，启动工程，访问http://localhost:8880/config可以看到成功获取到message:
![运行结果](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190305093501265.png)
## 二、服务发现(使用FeignClient调用)
### 创建服务提供者
新建service-discovery模块（空的maven项目），创建完成后删除src目录修改pom文件内容如下：
```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <parent>
          <artifactId>spring-cloud-alibaba-demo</artifactId>
          <groupId>com.xiaobai</groupId>
          <version>1.0-SNAPSHOT</version>
       </parent>
       <modelVersion>4.0.0</modelVersion>
       <packaging>pom</packaging>

       <artifactId>service-discovery</artifactId>

       <modules>
          <module>service-provider</module>
          <module>service-consumer</module>
       </modules>

    </project>
```
在service-discovery模块再创建service-provider子模块，选择Spring Initializr创建Spring Boot工程，依赖选择：
![创建service-provider子模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/2019030509431343.png)
创建完成后修改pom文件parent节点并添加Spring Cloud依赖：
```xml
    <properties>
          <spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
       </properties>

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
```
和nacaos-discovery依赖：
```xml
    <dependency>
       <groupId>org.springframework.cloud</groupId>
       <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
       <version>0.2.1.RELEASE</version>
    </dependency>
```
完整pom文件如下：
```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <parent>
          <groupId>com.xiaobai</groupId>
          <artifactId>service-discovery</artifactId>
          <version>1.0-SNAPSHOT</version>
       </parent>
       <groupId>com.xiaobai</groupId>
       <artifactId>service-provider</artifactId>
       <version>0.0.1-SNAPSHOT</version>
       <name>service-provider</name>
       <description>Demo project for Spring Boot</description>

       <properties>
          <java.version>1.8</java.version>
          <spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
       </properties>

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

       <dependencies>
          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-web</artifactId>
          </dependency>

          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-test</artifactId>
             <scope>test</scope>
          </dependency>

          <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
             <version>0.2.1.RELEASE</version>
          </dependency>
       </dependencies>

       <build>
          <plugins>
             <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
             </plugin>
          </plugins>
       </build>

    </project>
```
修改application.yml(application.properties)配置文件:
```yaml
    server:
      port: 8888
    spring:
      application:
        name: service-provider
      cloud:
        nacos:
          discovery:
            server-addr: x.x.x.x:8848
```
server-addr是nacos注册中心的地址。
启动类添加@EnableDiscoveryClient注解：
```java
    package com.xiaobai.serviceprovider;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

    @SpringBootApplication
    @EnableDiscoveryClient
    public class ServiceProviderApplication {

        public static void main(String[] args) {
            SpringApplication.run(ServiceProviderApplication.class, args);
        }

    }
```
在com.xiaobai.serviceprovider.service下新建SayHelloService接口：
```java
    package com.xiaobai.serviceprovider.service;

    public interface SayHelloService {
        public String sayHello(String name);
    }
```
在com.xiaobai.serviceprovider.service.Impl下新建接口的实现类：
```java
        package com.xiaobai.serviceprovider.service.Impl;

        import com.xiaobai.serviceprovider.service.SayHelloService;
        import org.springframework.stereotype.Service;

        @Service
        public class SayHelloImpl implements SayHelloService {
            public String sayHello(String name){
                return "Hello " + name + "!";
            }
        }
```
    在com.xiaobai.serviceprovider.controller下新建SayHelloController:
```java
    package com.xiaobai.serviceprovider.controller;

    import com.xiaobai.serviceprovider.service.SayHelloService;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestParam;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    public class SayHelloController {
        @Autowired
        private SayHelloService sayHelloService;
        @RequestMapping("/sayHello")
        public String sayHello(@RequestParam("name")String name){
            return sayHelloService.sayHello(name);
        }
    }
```
启动项目，查看nacos服务管理中已经注册成功：
![运行结果](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190305102753436.png)
### 创建服务消费者
在service-discovery模块再创建service-consumer子模块，选择Spring Initializr创建Spring Boot工程，依赖选择：
![创建service-consumer子模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190305103016412.png)
![创建service-consumer子模块](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190305103031980.png)
创建完成后修改pom文件parent节点并添加nacos-discovery依赖：
```xml
    <dependency>
       <groupId>org.springframework.cloud</groupId>
       <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
       <version>0.2.1.RELEASE</version>
    </dependency>
```
完整pom文件如下：
```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <parent>
          <groupId>com.xiaobai</groupId>
          <artifactId>service-discovery</artifactId>
          <version>1.0-SNAPSHOT</version>
       </parent>
       <groupId>com.xiaobai</groupId>
       <artifactId>service-consumer</artifactId>
       <version>0.0.1-SNAPSHOT</version>
       <name>service-consumer</name>
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
             <artifactId>spring-cloud-starter-openfeign</artifactId>
          </dependency>

          <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-test</artifactId>
             <scope>test</scope>
          </dependency>

          <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
             <version>0.2.1.RELEASE</version>
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
修改application.yml(application.properties)配置文件:
```yaml
    server:
      port: 80
    spring:
      application:
        name: service-consumer
      cloud:
        nacos:
          discovery:
            server-addr: x.x.x.x:8848
```
启动类添加@EnableDiscoveryClient和@EnableFeignClients注解：
```java
    package com.xiaobai.serviceconsumer;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
    import org.springframework.cloud.openfeign.EnableFeignClients;

    @SpringBootApplication
    @EnableDiscoveryClient
    @EnableFeignClients
    public class ServiceConsumerApplication {

        public static void main(String[] args) {
            SpringApplication.run(ServiceConsumerApplication.class, args);
        }

    }
```
在com.xiaobai.serviceconsumer.service下新建接口SayHelloService:
```java
    package com.xiaobai.serviceconsumer.service;

    import org.springframework.cloud.openfeign.FeignClient;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestParam;

    @FeignClient("service-provider")
    public interface SayHelloService {
        @RequestMapping("/sayHello")
        public String sayHello(@RequestParam("name")String name);
    }
```
在com.xiaobai.serviceconsumer.controller下新建TestController：
```java
    package com.xiaobai.serviceconsumer.controller;

    import com.xiaobai.serviceconsumer.service.SayHelloService;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestParam;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    public class TestController {
        @Autowired
        private SayHelloService sayHelloService;
        @RequestMapping("/test")
        public String test(@RequestParam("name")String name){
            return sayHelloService.sayHello(name);
        }
    }
```
启动项目，查看nacos服务管理，看到消费者已经注册成功：
![运行结果](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190305104116656.png)
访问http://localhost/test?name=xiaobai看到成功调用到service-provider的服务：
![运行结果](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/SpringCloudAlibaba/20190305104214440.png)
