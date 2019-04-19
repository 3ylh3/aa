---
title: HashMap的put方法解析
date: 2019-04-19 09:56:18
categories: 数据结构和算法
tags:
 - HashMap
---
jdk1.8以后，HashMap底层是用一个数组加链表和红黑树实现的，当链表长度超过8个时转为红黑树，当红黑树节点个数少于6个时转为链表，默认装填因子(loadFactor)是0.75，默认数组容量(capacity)是16（capacity的大小总是2的n次方），默认临界值(threshold)是12（loadFactor * capacity），当HashMap的size大于临界值threshold时就会进行扩容，图解：  
<!-- more -->
![HashMap](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/HashMap%E7%9A%84put%E6%96%B9%E6%B3%95%E8%A7%A3%E6%9E%90/hashmap.png)    
HashMap的put方法是调用了putVal方法，如下：  
```java
public V put(K key, V value) {
    return putVal(hash(key), key, value, false, true);
}
```
其中hash方法是用于生成key的hash值，具体实现如下：  
```java
static final int hash(Object key) {
    int h;
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
```
首先获得key的hashCode值，然后将hashCode值右移16位，然后将右移后的值与原来的hashCode做异或运算，返回结果。
putVal方法中的具体流程如下：  
 1. 如果table为空或者table的长度是0，则进行扩容。
 2. 根据hash计算数组索引i（注意这里不是用hash模数组长度，而是用数组长度减一与上key的hash值：i = (n - 1) & hash，因为数组长度是2的n次方，所以(n-1)&hash就等价于hash%n，&的运算效率高于%，所以这样算）。
 3. 如果table[i]为空，则将需要插入的node直接插入数组中，如果不为空进行步骤4。
 4. 如果table[i]处节点的key值和需要插入的key相同（判断方法：table[i]处节点的key的hash值等于需要插入节点key的hash值而且两者key相等或者用equals判断两者key返回true），则将table[i]赋给e，如果不相同进行步骤5。
 5. 如果table[i]是红黑树节点，则调用红黑树的插入方法，将返回值赋给e，如果不是，进行步骤6。
 6. 遍历链表，如果不存在key值相同（判断方法同上）的节点，则在链表后插入新节点，并判断链表长度是否超过8，如果超过则将联表转为红黑树；如果存在key值相同的节点，则将该节点赋给e。
 7. 判断如果e不是null，则代表HashMap中已经存在key是要插入节点的key值得数据，直接将新value覆盖e的value。
 8. 将size加一，判断如果超过临界值，则扩容。
  
流程图如下：  
![putVal方法流程](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/HashMap%E7%9A%84put%E6%96%B9%E6%B3%95%E8%A7%A3%E6%9E%90/putVal%E6%96%B9%E6%B3%95%E6%B5%81%E7%A8%8B.png)