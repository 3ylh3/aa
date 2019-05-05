---
title: MyBatis动态SQL
date: 2019-05-05 10:17:48
categories: 框架
tags: MyBatis
---
动态SQL是MyBatis的一个强大特性，它避免了拼接SQL时一系列的麻烦。
#### if标签
考虑以下一个常见的需求：有一个用户表user，要求根据用户名username模糊查询，如果为空则查询全部。使用MyBatis的动态SQL可以很轻松的完成：
<!-- more -->
```xml
<select id="queryUserByUsername">
    select * from user
    <if test="username != null">
        where username like #{username}
    </if>
</select>
```
if标签可以对username进行判空，根据结果来选择是否拼接模糊查询的条件。
#### choose、when、otherwise
再考虑下面一种情景：如果入参用户id不为空则按照id精确查询，否则按照用户名模糊查询(id和username必输一项)。使用choose、when和otherwise标签可以实现：
```xml
<select id="queryUserByIdOrUsername">
    select * from user where
    <choose>
        <when test="id != null">
            id = #{id}
        </when>
        <otherwise>
            username like #{username}
        </otherwise>
    </choose>
</select>
```
#### where标签
上面的例子也可以用where标签实现：
```xml
<select id="queryUserByIdOrUsername">
    select * from user
    <where>
        <if test="id != null">
            id = #{id}
        </if>
        <if test="username != null">
            username like #{username}
        </if>
    </where>
</select>
```
where标签只会在至少有一个子条件为真时才会插入where子句，而且当语句开头是and或者or时会自动去除。
#### foreach标签
除此之外，MyBatis还有非常强大的foreach标签，它提供对一个集合（可以使List、Set和Map等）的遍历，当使用可迭代对象或数组时，index是当前迭代次数，item是本次迭代取到的值；当是Map时，index是本次迭代取到的键，item是值。按照惯例我们来举个栗子：查询给定id(个数不确定，入参是一个List)的所有用户信息：
```xml
<select id="queryUserByIds">
    select * from user where id in
    <foreach item="id" collection="idList" open="(" separator="," close=")">
        #{id}
    </foreach>
</select>
```
其中collection是入参的List,open是开头字符串，close是结尾字符串，separator是分隔字符，最终的SQL会是：
```sql
select * from user where id in (....)
```
动态SQL同样可以用在注解中，只要加上script标签即可，以foreach为例：
```java
@Select(
    "<scirpt>" +
        "select * from user where id in" +
        "<foreachitem='id' collection='idList' open='(' separator=',' close=')'>#{id}</foreach>" +
    "</script>"
)
```