---
title: Java实现SHA-1散列函数
date: 2019-04-09 10:08:14
categories: Java
tags:
 - SHA-1
---
SHA-1是一种安全散列算法，也是一种哈希函数，它能够将任意长度的信息散列成160位（bit）的消息摘要，散列值通常表示为40个十六进制数，结果是不可逆的。SHA-1主要数字签名，来验证数据的完整性。Java提供了MessageDigest类，可以用来实现SHA-1算法。MessageDigest.digest()方法返回的是byte数组，而SHA-1的结果常表示为40为十六进制数，因此需要进行转化，转化原理如下：  
首先将byte数组每一位转为int类型，然后调用Integer.toHexString转为十六进制字符串，拼接到一个StringBuffer中，全部处理完后，将StringBuffer转为String即可。需要注意的是byte转为int需要进行与操作：& 0xFF，目的是为了保证二进制数据的一致性，举个例子：一个byte是8个二进制位，例如byte类型的-12表示为1111 0100（负数补码表示，12的原码是0000 1100，补码就是取反1111 0011然后加1），如果直接转为int类型，那么就是前24位补1，就会变为1111 1111 1111 1111 1111 1111 1111 0100，会造成二进制补码不一致，所以需要与操作来实现：0x代表十六进制，F代表15,0xFF二进制表示为1111 1111，高24位补0与-12的补码表示进行与操作得到0000 0000 0000 0000 0000 0000 1111 0100，可以将高24位置为0，低8位保持不变，这样就保证了二进制补码的一致性。具体代码如下：  
<!-- more -->
```Java
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA1 {
    public static void main(String[] args) {
        try {
            String str = "Hello World!";
            //生成MessageDigest对象
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            //更新摘要
            md.update(str.getBytes());
            //生成摘要
            byte[] data = md.digest();
            //将结果转为十六进制字符串
            StringBuffer hexstr = new StringBuffer();
            String s = "";
            for (int i = 0; i < data.length; i++) {
                s = Integer.toHexString(data[i] & 0xFF);
                //一个十六进制数4位，所以一个byte用两个十六进制数表示，不足的左补零
                if (s.length() < 2) {
                    hexstr.append(0);
                }
                hexstr.append(s);
            }
            String result = hexstr.toString();
            System.out.println("result:" + result);
        }
        catch (NoSuchAlgorithmException e){
            e.printStackTrace();
        }
    }
}
```
MessageDigest类也提供MD5的支持，只需要将getInstance的参数变为MD5即可。
