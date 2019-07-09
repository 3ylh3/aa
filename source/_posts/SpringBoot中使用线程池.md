---
title: SpringBoot中使用线程池
date: 2019-07-09 16:28:57
categories: 框架
tags:
 - Spring Boot
 - 线程池
---
在使用多线程时，如果并发数很大，并且每个线程执行很短的任务就结束，那么频繁的创建销毁线程就会造成很大的系统开销，降低系统的效率，线程池可以很好的解决这个问题。在SpringBoot工程中只需做很简单的配置就可以使用线程池。
<!-- more -->
首先在配置文件中定义相关配置项：
```properties
#线程池配置
#核心线程数
executor.thread.coreSize=5
#最大线程数
executor.thread.maxSize=8
#队列大小
executor.thread.queueCapacity=100
#当线程数大于coresize时，空闲线程保持时间
executor.thread.keepAliveSeconds=10
#线程名称前缀
executor.thread.namePrefix=test-thread
```
其中coreSize是核心池大小，maxSize是最大线程数，queueCapacity是配置队列容量，keepAliveSeconds是空闲线程保持时间（只有当线程池中的线程数量大于coreSize时才生效），namePrefix是线程名称前缀。
当线程池创建后，默认情况下池中没有任何线程，只有当有任务时才会创建线程去执行任务，当线程数量达到coreSize时，之后到达的任务会被存放进缓存队列中。
举个不恰当的例子：
假如有一个餐馆有5名清洁工负责刷盘子，每个人一次只刷一个盘子，当5个清洁工都在刷盘子时，再来的脏盘子就会被暂时放在搁置架上。工作了一段时间餐馆老板发现脏盘子太多了，5个清洁工刷不过来，就又招了3个临时工帮忙刷盘子。过了一段时间餐馆生意不红火了，没有那么多脏盘子刷了，老板就决定3个临时工如果有人闲下来10秒没事做就把他解雇（这个时间有点太不人道了。。。。），那么这个例子映射到线程池的配置就是coreSize=5，maxSize=8,keepAliviSeconds=10。
接下来新建线程池配置类：
```java
package com.xiaobai.springboottask.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.AsyncConfigurer;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * 线程池配置类
 *
 * @author 小白
 * @date 2019/7/9
 */
@Configuration
@EnableAsync
public class ExecutorConfig implements AsyncConfigurer {
    /**
     * 核心线程数
     */
    @Value("${executor.thread.coreSize}")
    private int coreSize;

    /**
     * 最大线程数
     */
    @Value("${executor.thread.maxSize}")
    private int maxSize;

    /**
     * 队列大小
     */
    @Value("${executor.thread.queueCapacity}")
    private int queueCapacity;

    /**
     * 空闲线程保持时间
     */
    @Value("${executor.thread.keepAliveSeconds}")
    private int keepAliveSeconds;

    /**
     * 线程名称前缀
     */
    @Value("${executor.thread.namePrefix}")
    private String prefix;

    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(coreSize);
        executor.setMaxPoolSize(maxSize);
        executor.setQueueCapacity(queueCapacity);
        executor.setKeepAliveSeconds(keepAliveSeconds);
        executor.setThreadNamePrefix(prefix);
        // 当线程数量已经达到maxSize的时候，如何处理新任务
        // CallerRunsPolicy：不在新线程中执行任务，而是由调用者所在的线程来执行
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.initialize();
        return executor;
    }
}
```
注意executor.setRejectedExecutionHandler是设置了线程数量达到maxSize后的处理策略，共有以下四种策略：
 - ThreadPoolExecutor.AbortPolicy:丢弃任务并抛出RejectedExecutionException异常。 
 - ThreadPoolExecutor.DiscardPolicy：也是丢弃任务，但是不抛出异常。 
 - ThreadPoolExecutor.DiscardOldestPolicy：丢弃队列最前面的任务，然后重新尝试执行任务（重复此过程）
 - ThreadPoolExecutor.CallerRunsPolicy：由调用线程处理该任务 
创建任务执行接口：
```java
package com.xiaobai.springboottask.service;

/**
 * 线程任务接口
 *
 * @author 小白
 * @date 2019/7/9
 */
public interface ExecutorService {

    /**
     * 执行任务
     */
    void executeTask();
}
```
创建对应的实现类：
```java
package com.xiaobai.springboottask.service.impl;

import com.xiaobai.springboottask.service.ExecutorService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * 线程任务实现类
 *
 * @author 小白
 * @date 2019/7/9
 */
@Service
public class ExecutorServiceImpl implements ExecutorService {
    private Logger logger = LoggerFactory.getLogger(ExecutorServiceImpl.class);

    @Override
    @Async
    public void executeTask() {
        logger.info("do task...");
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e){
            logger.info(e.toString());
        }
        logger.info("finish");
    }
}
```
创建一个调用任务的controller:
```java
package com.xiaobai.springboottask.controller;

import com.xiaobai.springboottask.service.ExecutorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 执行任务controller
 *
 * @author 小白
 * @date 2019/7/9
 */
@RestController
public class ExecuteTaskController {
    @Autowired
    private ExecutorService executorService;

    @RequestMapping("/execute")
    public void execute(){
        executorService.executeTask();
    }
}
```
调用几次controller会看到以下结果：
```
2019-07-09 17:12:55.426  INFO 22220 --- [   test-thread1] c.x.s.service.impl.ExecutorServiceImpl   : do task...
2019-07-09 17:12:56.427  INFO 22220 --- [   test-thread1] c.x.s.service.impl.ExecutorServiceImpl   : finish
2019-07-09 17:12:58.257  INFO 22220 --- [   test-thread2] c.x.s.service.impl.ExecutorServiceImpl   : do task...
2019-07-09 17:12:59.259  INFO 22220 --- [   test-thread2] c.x.s.service.impl.ExecutorServiceImpl   : finish
2019-07-09 17:13:00.581  INFO 22220 --- [   test-thread3] c.x.s.service.impl.ExecutorServiceImpl   : do task...
2019-07-09 17:13:01.582  INFO 22220 --- [   test-thread3] c.x.s.service.impl.ExecutorServiceImpl   : finish
2019-07-09 17:13:04.136  INFO 22220 --- [   test-thread4] c.x.s.service.impl.ExecutorServiceImpl   : do task...
2019-07-09 17:13:05.137  INFO 22220 --- [   test-thread4] c.x.s.service.impl.ExecutorServiceImpl   : finish
2019-07-09 17:13:06.285  INFO 22220 --- [   test-thread5] c.x.s.service.impl.ExecutorServiceImpl   : do task...
2019-07-09 17:13:07.287  INFO 22220 --- [   test-thread5] c.x.s.service.impl.ExecutorServiceImpl   : finish
```
完整代码已经上传github:
https://github.com/3ylh3/SpringBootExcutor