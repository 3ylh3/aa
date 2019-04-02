---
title: springboot整合dubbo
date: 2019-04-02 16:21:01
categories: 框架
tags:
  - Spring Boot
  - Dubbo
---
这两天参考各种资料在做springboot整合dubbo，这里记录下。
整个工程由dubbo-provider和dubbo-consumer两个模块构成，完整目录如下：
具体步骤：
## 1.使用IDEA创建一个空的MAVEN项目
<!-- more -->
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/f00a6a8b6121841e97d516496c0e0e77?fid=4047388677-250528-889631082045160&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-AZQm8UhITRwl2wIwHhxM0ZvnSzA%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2126396088996938062&dp-callid=0&time=1554192000&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
项目创建完成后，删除src目录，在pom.xml中添加
```xml
    <packaging>pom</packaging>
    <modules>
       <module>dubbo-provider</module>
        <module>dubbo-consumer</module>
    </modules>
```
  完整pom文件如下：
```xml

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.xiaobai</groupId>
       <artifactId>springboot-dubbo</artifactId>
       <version>1.0-SNAPSHOT</version>
       <packaging>pom</packaging>

       <modules>
          <module>dubbo-provider</module>
          <module>dubbo-consumer</module>
       </modules>


    </project>
```
## 2.创建dubbo-provider子模块
新建模块
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/7b58a5926d6ec021a4aa55752d0649d1?fid=4047388677-250528-725530202264110&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-LDD3DdSK22up98o0ncFMVoOYLsQ%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2126558072670143744&dp-callid=0&time=1554192000&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
选择Spring Intializr
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/675ccafb9bb4d86adf94724f61126c34?fid=4047388677-250528-683288344355521&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-YBMxE9p4JG0TN1N0uZdDomExuqU%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2126616092065418303&dp-callid=0&time=1554192000&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
选择web(这里需要注意，如果不创建web工程的话整个dubbo-provider工程运行完就会退出)
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/1d55e6b205cf3813bf6c676108d4cc29?fid=4047388677-250528-1023206244496065&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-L8%2bKdOXoiYWfxF3oWVMDm1O%2fPJM%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2126684829980598338&dp-callid=0&time=1554192000&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
在pom文件中添加dubbo-springboot依赖和zookeeper依赖：
```xml
<!--dubbo-springBoot依赖-->
      <dependency>
         <groupId>com.alibaba.spring.boot</groupId>
         <artifactId>dubbo-spring-boot-starter</artifactId>
         <version>2.0.0</version>
      </dependency>
      <!--zookeeper依赖-->
      <dependency>
         <groupId>org.apache.zookeeper</groupId>
         <artifactId>zookeeper</artifactId>
         <version>3.4.11</version>
      </dependency>
      <dependency>
         <groupId>com.101tec</groupId>
         <artifactId>zkclient</artifactId>
         <version>0.11</version>
      </dependency>
```
dubbo-provider模块完整pom文件如下：
```xml


    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <parent>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter-parent</artifactId>
          <version>2.1.3.RELEASE</version>
          <relativePath/> <!-- lookup parent from repository -->
       </parent>
       <groupId>com.xiaobai</groupId>
       <artifactId>dubbo</artifactId>
       <version>0.0.1-SNAPSHOT</version>
       <name>dubbo</name>
       <description>Demo project for Spring Boot</description>

       <properties>
          <java.version>1.8</java.version>
       </properties>

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

          <!--dubbo-springBoot依赖-->
          <dependency>
             <groupId>com.alibaba.spring.boot</groupId>
             <artifactId>dubbo-spring-boot-starter</artifactId>
             <version>2.0.0</version>
          </dependency>
          <!--zookeeper依赖-->
          <dependency>
             <groupId>org.apache.zookeeper</groupId>
             <artifactId>zookeeper</artifactId>
             <version>3.4.11</version>
          </dependency>
          <dependency>
             <groupId>com.101tec</groupId>
             <artifactId>zkclient</artifactId>
             <version>0.11</version>
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
修改dubbo-provider模块的application.properties配置文件内容为(我习惯用yml文件,因此这里用的是application.yml):
```yml
    spring:
      dubbo:
        application:
          name: dubbo-provider
        registry:
          address: zookeeper://x.x.x.x:2181
        protocol:
          name: dubbo
          port: 20880
```
其中
```yml
    registry:
      address: zookeeper://x.x.x.x:2181
```
是zookeeper的ip和端口，如果安装在本地，那么127.0.0.1:2181就可以；
接下来给dubbo-provider模块的入口类添加@EnableDubboConfiguration注解：
```java


    package com.xiaobai.dubbo;

    import com.alibaba.dubbo.spring.boot.annotation.EnableDubboConfiguration;
    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;

    @SpringBootApplication
    @EnableDubboConfiguration
    public class DubboApplication {

        public static void main(String[] args) {
            SpringApplication.run(DubboApplication.class, args);
        }

    }
```
在com.xiaobai.dubbo.service下新建接口DubboProviderService.java:
```java
    package com.xiaobai.dubbo.service;

    public interface DubboProviderService {
        public String provider(String name);
    }
```
在com.xiaobai.dubbo.service.Impl下新建接口的实现类DubboProviderImpl.java:
```java


    package com.xiaobai.dubbo.service.Impl;

    import com.alibaba.dubbo.config.annotation.Service;
    import com.xiaobai.dubbo.service.DubboProviderService;
    import org.springframework.stereotype.Component;

    @Component
    @Service
    public class DubboProviderImpl implements DubboProviderService {
        public String provider(String name){
            return "Hello " + name;
        }
    }
```

这里要注意@Service注解使用的是com.alibaba.dubbo.config.annotation.Service，作用是把服务类暴露出去。
## 3.创建dubbo-consumer模块
按照同样的方法新建dubbo-consumer模块。
dubbo-consumer模块的pom文件中需要额外添加thymeleaf依赖，以实现动态页面的访问：
```xml
    <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>
```
dubbo-consumer模块完整的pom文件如下：
```xml
        <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <parent>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter-parent</artifactId>
          <version>2.1.3.RELEASE</version>
          <relativePath/> <!-- lookup parent from repository -->
       </parent>
       <groupId>com.xiaobai</groupId>
       <artifactId>dubbo</artifactId>
       <version>0.0.1-SNAPSHOT</version>
       <name>dubbo</name>
       <description>Demo project for Spring Boot</description>

       <properties>
          <java.version>1.8</java.version>
       </properties>

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
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-thymeleaf</artifactId>
          </dependency>

          <!--dubbo-springBoot依赖-->
          <dependency>
             <groupId>com.alibaba.spring.boot</groupId>
             <artifactId>dubbo-spring-boot-starter</artifactId>
             <version>2.0.0</version>
          </dependency>
          <!--zookeeper依赖-->
          <dependency>
             <groupId>org.apache.zookeeper</groupId>
             <artifactId>zookeeper</artifactId>
             <version>3.4.11</version>
          </dependency>
          <dependency>
             <groupId>com.101tec</groupId>
             <artifactId>zkclient</artifactId>
             <version>0.11</version>
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
dubbo-consumer模块的application.yml配置文件内容如下：
```yml
    server:
      port: 80

    spring:
      dubbo:
        application:
          name: dubbo-consumer
        registry:
          address: zookeeper://x.x.x.x:2181
        protocol:
          name: dubbo
          port: 20880
```
这里将端口改为80是为了防止和dubbo-provider模块冲突。
入口类同样需要添加@EnableDubboConfiguration注解。
然后在com.xiaobai.dubbo.service下新建接口DubboProviderService.java：
```java
package com.xiaobai.dubbo.service;

    public interface DubboProviderService {
        public String provider(String name);
    }
```
在com.xiaobai.dubbo.controller下新建ConsumerController.java：
```java
    package com.xiaobai.dubbo.controller;

    import com.alibaba.dubbo.config.annotation.Reference;
    import com.xiaobai.dubbo.service.DubboProviderService;
    import org.springframework.stereotype.Controller;
    import org.springframework.ui.Model;
    import org.springframework.web.bind.annotation.RequestMapping;

    @Controller
    public class ConsumerController {
        @Reference
        private DubboProviderService dubboProviderService;
        @RequestMapping("/consumer")
        public String consumer(Model model){
            String message = dubboProviderService.provider("xiaobai");
            model.addAttribute("message",message);
            return "consumer";
        }
    }
```
注意@Reference注解使用的是com.alibaba.dubbo.config.annotation.Reference，作用是调用dubbo-provider的服务。
接下来在resources/templates下新建consumer.html：
```html
    <!DOCTYPE html>
    <html lang="en" xmlns:th="http://www.thymeleaf.org">
    <head>
        <meta charset="UTF-8">
        <title>consumer</title>
    </head>
    <body>
    <p th:text="${message}"></p>
    </body>
    </html>
```
然后启动dubbo-provider模块的启动类，再启动dubbo-consumer模块的启动类，查看dobbo-admin控制台：
![在这里插入图片描述](https://thumbnail10.baidupcs.com/thumbnail/8d1f2c2f59031adca4f215ebb9a55459?fid=4047388677-250528-970787039850048&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-TCqDCpZj3nA1Advmt3PlOf%2bsGDI%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2126737653605660974&dp-callid=0&time=1554192000&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
提供者和消费者均注册成功，此时访问http://localhost/consumer会看到
![在这里插入图片描述](https://thumbnail0.baidupcs.com/thumbnail/2870fe6f0d76d25569cffb20e1211238?fid=4047388677-250528-953467816851266&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-D%2fZTeK3NSSv2bXpevvHZXkjzQVA%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2126761753132057852&dp-callid=0&time=1554192000&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1)
至此springboot和dubbo整合完成。
完整的代码以上传到github:
https://github.com/3ylh3/springboot-dubbo.git
