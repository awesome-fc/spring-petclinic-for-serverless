## 应用简介

[Spring Petclinic](https://github.com/spring-projects/spring-petclinic) 是一个 Spring Boot 、Spring MVC 和 Spring Data 结合使用的示例项目，是学习 Spring Boot 经典案例。

本应用模板使用函数计算的 [Custom 运行时](https://help.aliyun.com/document_detail/132044.html)和 [RDS-MySQL 云服务](https://cn.aliyun.com/product/rds/mysql)作为 Spring Boot 应用的运行环境。借助于[资源编排服务（ROS）](https://cn.aliyun.com/product/ros)的能力，该模板会自动创建 VPC、VSwitch、SecurityGroup、RDS 和绑定了 HTTP Trigger 的函数，以及绑定到 HTTP 函数的自定义域名，并自动配置好这些服务，以达到迅速上线开箱即用的效果。

注意：

1. 需要提供一个域名（支持二级域名），如果部署在国内 Region 该域名需要在阿里云备案，然后把域名的 CNAME 记录指向 `12345.cn-shanghai.fc.aliyuncs.com`，其中 `12345` 换成您的 AccountID，如果是在国外 Region 可以免去备案环节，[请查看更多参考](https://help.aliyun.com/document_detail/90722.html)
2. 模板创建的 [RDS-MySQL 云服务](https://cn.aliyun.com/product/rds/mysql)选用了最便宜的按量付费实例，费用大约为：￥0.236/小时，使用前需要确保账户有 100 元的余额，并且试用完成以后建议通过 [ROS 控制台](https://rosnext.console.aliyun.com/)删除该应用，以免产生超出预期的费用。


![](https://img.alicdn.com/tfs/TB1MBzgr7T2gK0jSZFkXXcIQFXa-2084-1334.png)


## 工作原理

本示例中，我们打算使用函数计算的 [Custom 运行时](https://help.aliyun.com/document_detail/132044.html) 来移植 Petclinic 项目。顾名思义， Custom Runtime 就是自定义的执行环境， 用户基于 Custom Runtime 可以完成以下目标：

* 可以随心所欲持定制个性化语言执行环境（例如 Golang、Lua、Ruby）以及各种语言的小版本（例如 Python3.7、Nodejs12 )等，打造属于自己的自定义 Runtime
* 现有的 Web 应用或基于传统开发 Web 项目基本不用做任何改造，即可将项目一键迁移到函数计算平台

该应用的架构图如下：

![](https://img.alicdn.com/tfs/TB1uE4BsAL0gK0jSZFxXXXWHVXa-1080-645.png)

项目源码：https://github.com/awesome-fc/spring-petclinic-for-serverless