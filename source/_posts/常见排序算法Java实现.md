---
title: 常见排序算法Java实现
date: 2019-03-28 15:53:47
tags: 排序算法
mathjax: true
---
#### 1.冒泡排序
冒泡排序的思想是遍历若干次数组，每次遍历从左往右比较相邻两个数大小，如果左边的元素大于右边的，则交换位置，这样一次遍历后最大的一个元素就会在数组尾部。冒泡排序时间复杂度是$$O(n^2)$$,是稳定的算法。  
算法稳定性 -- 假设在数列中存在a[i]=a[j]，若在排序之前，a[i]在a[j]前面；并且排序之后，a[i]仍然在a[j]前面。则这个排序算法是稳定的。  
<!-- more -->
java实现：
```java
/**
 * 冒泡排序
 * @param a 需要排序的整型数组
 */
public void bubbleSort(int[] a){
    for(int i = 1;i <= a.length;i++){
        for(int j = 0;j < a.length - i;j++){
            //从数组第一个数开始，依次和它后面的数比较，如果比后面的数大，则交换位置
            if(a[j] > a[j + 1]){
                int tmp = a[j];
                a[j] = a[j + 1];
                a[j + 1] = tmp;
            }
        }
    }
}
```
#### 2.快速排序
快速排序的思想是选一个基准数，通过一趟排序把所有小于基准值的数放在基准值左边，把大于基准值的数放在基准值右边，然后递归对左右两部分进行排序。快速排序的最坏时间复杂度是$$O(n^2)$$,平均时间复杂度是$$O(n*\lg n)$$，是不稳定的排序算法。  
java实现：
```java
/**
 * 快速排序
 * @param a 需要排序的数组
 * @param l 左边界
 * @param r 右边界
 */
public void quickSort(int[] a,int l,int r){
    if(l >= r){
        return;
    }
    //基准值取a[i]
    int base = a[l];
    int i = l;
    int j = r;
    //当i小于j时循环
    while(i < j){
        //从右向左找出第一个小于base的数，和a[i]交换
        while(i < j){
            if(a[j] < base){
                a[i] = a[j];
                break;
            }
            else{
                j--;
            }
        }
        //从左向右找出第一个大于base的数，和a[j]交换
        while(i < j){
            if(a[i] > base){
                a[j] = a[i];
                break;
            }
            else{
                i++;
            }
        }
    }
    //将a[i]设为base
    a[i] = base;
    //递归调用
    quickSort(a,l,i - 1);
    quickSort(a,i + 1,r);
}
```
#### 3.直接插入排序
直接插入排序的思想是讲数组分为有序表和无序表两个部分，开始时有序表只含有1个元素（数组第一个元素），无序表中含有n-1个元素，n为数组长度，每趟排序从无序表中取出一个元素插入到有序表中对应的位置，重复n-1次可完成排序过程。直接插入排序的时间复杂度是$$O(n^2)$$,是稳定的排序算法。  
java实现：
```java
/**
 * 直接插入排序
 * @param a 待排序数组
 */
public void insertSort(int[] a){
    //循环处理无序表元素
    for(int i = 1;i < a.length;i++){
        //寻找在有序表中插入位置,将后面的元素后移一位后插入
        int tmp = a[i];
        int j = i - 1;
        for(;j >= 0;j--){
            if(a[j] > tmp){
                a[j + 1] = a[j];
                a[j] = tmp;
            }
        }
    }
}
```
#### 4.希尔排序
希尔排序是插入排序的一种，是针对直接插入排序算法的改进，又称缩小增量排序，实质上是一种分组的插入排序算法，基本思想是选取一个增量increment(又称步长),将数组分成increment个组，分别对每个组进行直接插入排序，然后缩小increment的值，重复上述排序过程，当increment为1时，整个数组就是有序的，希尔排序的时间复杂度和步长有关，是不稳定的排序算法，假设步长是4,待排序数组是{10,2,8,7,9,3,4,1,6,5}，则第一趟排序图解如下：
![希尔排序](http://47.93.194.195/shellSort.png)
步长是4，分成四组{10,9,6}、{2,3,5}、{8，4}、{7,1}，第一趟排序后四组分别为{6,9,10}、{2,3,5}、{4,8}、{1,7}，整个数组为{6,2,4,19,3,8,7,10,5}。  
java实现：
```java
/**
 * 希尔排序
 * @param a 待排序数组
 * @param increment 步长
 */
public void shellSort(int[] a,int increment){
    //每次步长变为原来的一半
    for(;increment > 0;increment /= 2){
        //共increment个组，对每个组进行直接插入排序
        for(int in = 0;in < increment;in++){
            for(int i = in + increment;i < a.length;i += increment){
                //寻找在有序表中插入位置,将后面的元素后移一位后插入
                int tmp = a[i];
                int j = i - increment;
                for(;j >= in;j -= increment){
                    if(a[j] > tmp){
                        a[j + increment] = a[j];
                        a[j] = tmp;
                    }
                }
            }
        }
    }
}
```
#### 5.选择排序
选择排序的思想是在无序序列（初始为整个数组）中找出最小的数，和第一个数交换，接着再从剩余的数中找出最小的数放到已排序序列末尾，以此类推，直至完成排序。选择排序的时间复杂度是$$O(n^2)$$,是稳定的排序算法。
java实现：
```java
/**
 * 选择排序
 * @param a 待排序数组
 */
public void selectSort(int[] a){
    //从a[0]开始
    for(int i = 0;i < a.length;i++){
        //找出a[j] - a[a.length - 1]中最小的数
        int min = i;
        for(int j = i + 1;j < a.length;j++){
            if(a[j] < a[min]){
                min = j;
            }
        }
        //和a[i]交换
        int tmp = a[i];
        a[i] = a[min];
        a[min] = tmp;
    }
}
```
#### 6.堆排序
堆排序使用了大根堆，首先了解大根堆的概念，大根堆是特殊的二叉树，常用数组实现，有以下特性：
1. 索引为n的节点，它的左孩子索引为$$2*n+1$$。
2. 索引为n的节点，它的右孩子索引为$$2*n+2$$。
3. 索引为n的节点，它的父节点索引为$$floor((n-1)/2)$$。  

大根堆图示：  

![大根堆](https://gss0.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=28d03bd9f21f3a295a9dddc8a9159009/d52a2834349b033bff3166dd17ce36d3d539bd78.jpg)  

堆排序思想是将数组构建成一个大根堆，然后交换数组首尾元素，这样最大元素就在数组最后，接着把数组前面的元素再构建成大根堆并交换元素，以此类推直至数组变为有序的。堆排序的时间复杂度是$$O(n*lg n)$$，是不稳定的排序算法。  
大根堆调整算法的思想是从最后一个非叶子元素（索引为$$n/2-1$$,n是数组长度）开始调整，将它和它的左右孩子中较大的数比较，如果它小的话则交换，然后递归调整孩子节点。  
java实现：
```java
/**
 * 堆排序
 * @param a 待排序数组
 */
public void heapSort(int[] a){
    //将数组调整成大根堆,从最后一个非叶子节点开始调整
    for(int i = a.length / 2 - 1;i >= 0;i--) {
        adjust(a,i,a.length);
    }
    //将第一个数和最后一个数交换，然后将数组前面内容重新调整成大根堆
    for(int i = a.length - 1;i >= 0;i--){
        int tmp = a[i];
        a[i] = a[0];
        a[0] = tmp;
        //从最后一个非叶子节点开始调整，将剩余数组调整成大根堆
        for(int j = i / 2 - 1;j >= 0;j--){
            adjust(a,j,i);
        }
    }
}

/**
 * 大根堆调整算法
 * @param a 待调整数组
 * @param index 调整的节点
 * @param length 待调整数组长度
 */
public void adjust(int[] a,int index,int length){
    //记左右孩子中最大值的索引为max
    int max = index * 2 + 1;
    if ((index * 2 + 2) < length && a[max] < a[index * 2 + 2]) {
        max = index * 2 + 2;
    }
    //如果a[index]小于a[max]，则交换两者
    if (a[index] < a[max]) {
        int tmp = a[index];
        a[index] = a[max];
        a[max] = tmp;
        //如果max节点有孩子，则递归调整
        if (max * 2 + 1 < length) {
            adjust(a,max,length);
        }
    }
}
```
#### 7.归并排序
归并排序的思想是讲待排序序列从中间一分为二，然后递归的对两个序列进行归并排序，直至序列长度为1，然后将已经排序好的两个有序序列合并为一个有序序列。归并排序的时间复杂度是$$O(n*lg n)$$,是稳定的排序算法。   
java实现：
```java
/**
 * 归并排序
 * @param a 待排序数组
 * @param start 开始位置
 * @param end 结束位置
 */
public void mergeSort(int[] a,int start,int end){
    if(start < end){
        int mid = (end + start) / 2;
        //递归对左右两个序列进行排序
        mergeSort(a,start,mid);
        mergeSort(a,mid + 1,end);
        //合并两个有序序列
        merge(a,start,mid,end);
    }
}

/**
 * 合并两个有序序列
 * @param a 待合并序列
 * @param start 起始位置
 * @param mid 中间位置（第一个序列结束位置）
 * @param end 结束位置
 */
public void merge(int[] a,int start,int mid,int end){
    //辅助数组
    int[] tmp = new int[end - start + 1];
    int i = start;
    int j = mid + 1;
    int k = 0;
    //遍历第一个有序序列
    while(i <= mid){
        //如果第二个有序序列没有遍历完
        if(j <= end){
            //比较两个序列当前元素，将较小的放到辅助数组中
            if(a[i] < a[j]){
                tmp[k] = a[i];
                i++;
            }
            else{
                tmp[k] = a[j];
                j++;
            }
        }
        //如果第二个数组已经遍历完，则将第一个序列中剩余的数都放到辅助数组中
        else{
            tmp[k] = a[i];
            i++;
        }
        k++;
    }
    //如果第二个序列还没有遍历完，则将剩余的数全部放到辅助数组中
    while(j <= end){
        tmp[k] = a[j];
        j++;
        k++;
    }
    //将辅助数组中的数复制到原数组
    System.arraycopy(tmp,0,a,start,tmp.length);
}
```
#### 总结
排序算法 | 时间复杂度 | 是否稳定
-- | -- | --
冒泡排序 | $$O(n^2)$$ | 稳定
快速排序 |  最坏$$O(n^2)$$，平均$O(n*lg n)$ | 不稳定
直接插入排序 | $$O(n^2)$$ | 稳定
希尔排序 | 和选取的步长有关 | 不稳定
选择排序 | $$O(n^2)$$ | 稳定
堆排序 | $$O(n*lg n)$$ | 不稳定
归并排序 | $$O(n*lg n)$$ | 稳定
