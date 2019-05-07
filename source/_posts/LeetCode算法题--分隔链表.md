---
title: LeetCode算法题--分隔链表
date: 2019-05-07 10:40:50
categories: 数据结构和算法
tags:
 - 链表
 - LeetCode
---
#### 题目描述：  
给定一个链表和一个特定值 x，对链表进行分隔，使得所有小于 x 的节点都在大于或等于 x 的节点之前。  

你应当保留两个分区中每个节点的初始相对位置。  

示例:  

输入: head = 1->4->3->2->5->2, x = 3  
输出: 1->2->2->4->3->5  
<!-- more -->
#### 解题思路：  
遍历给定链表，分别用两个链表存储小于x的节点和大于等于x的节点，遍历完成后合并两个临时链表。
#### java实现：
```java
public class PartionList {
    public ListNode partition(ListNode head, int x) {
        if(head == null){
            return head;
        }
        //用两个链表来存储小于和大于等x的节点
        ListNode list1 = new ListNode(0);
        ListNode res1= list1;
        ListNode list2 = new ListNode(0);
        ListNode res2 = list2;
        //遍历链表
        while(head != null){
            //小于x的节点放到list1中
            if(head.val < x){
                ListNode tmp = new ListNode(head.val);
                list1.next = tmp;
                list1 = list1.next;
            }
            //大于等于x的节点放到list2中
            else{
                ListNode tmp = new ListNode(head.val);
                list2.next = tmp;
                list2 = list2.next;
            }
            head = head.next;
        }
        //合并两个链表
        if(res2.next != null){
            list1.next = res2.next;
        }
        return res1.next;
    }
}
```