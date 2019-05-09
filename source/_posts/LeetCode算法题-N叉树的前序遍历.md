---
title: LeetCode算法题--N叉树的前序遍历
date: 2019-05-09 09:56:14
categories: 数据结构和算法
tags:
 - 树
 - LeetCode
---
#### 题目描述：
589.
给定一个 N 叉树，返回其节点值的前序遍历。  

例如，给定一个 3叉树 :

![三叉树](https://xiaobai-picture.oss-cn-beijing.aliyuncs.com/LeetCode/narytreeexample.png)  

返回其前序遍历: [1,3,5,6,2,4]。  
<!-- more -->
#### 解题思路：  
使用递归的思想，首先把根节点的值放进一个list中，如果根节点有孩子，则递归对孩子调用。
#### Java实现：
```java
public List<Integer> preorder(Node root) {
    if(root == null){
        return new ArrayList<Integer>();
    }
    List<Integer> list = new ArrayList<Integer>();
    pre(list,root);
    return list;
}
public void pre(List list,Node root){
    list.add(root.val);
    Iterator<Node> i = root.children.iterator();
    while(i.hasNext()){
        pre(list,i.next());
    }
}
```