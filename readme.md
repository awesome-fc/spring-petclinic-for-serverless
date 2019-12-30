# 快速部署 Spring PetClinic 到函数计算平台

## 简介

首先介绍下在本文出现的几个比较重要的概念：

> **函数计算（Function Compute）**：[函数计算](https://statistics.functioncompute.com/?title=%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%20Spring%20PetClinic%20%E5%88%B0%E5%87%BD%E6%95%B0%E8%AE%A1%E7%AE%97%E5%B9%B3%E5%8F%B0&author=%E5%80%9A%E8%B4%A4&src=article&url=http%3A%2F%2Ffc.console.aliyun.com%2F%3Ffctraceid%3DYXV0aG9yJTNEJUU1JTgwJTlBJUU4JUI0JUE0JTI2dGl0bGUlM0QlRTUlQkYlQUIlRTklODAlOUYlRTklODMlQTglRTclQkQlQjIlMjBTcHJpbmclMjBQZXRDbGluaWMlMjAlRTUlODglQjAlRTUlODclQkQlRTYlOTUlQjAlRTglQUUlQTElRTclQUUlOTclRTUlQjklQjMlRTUlOEYlQjA%3D)是一个事件驱动的服务，通过函数计算，用户无需管理服务器等运行情况，只需编写代码并上传。函数计算准备计算资源，并以弹性伸缩的方式运行用户代码，而用户只需根据实际代码运行所消耗的资源进行付费。函数计算更多信息[参考](https://statistics.functioncompute.com/?title=%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%20Spring%20PetClinic%20%E5%88%B0%E5%87%BD%E6%95%B0%E8%AE%A1%E7%AE%97%E5%B9%B3%E5%8F%B0&author=%E5%80%9A%E8%B4%A4&src=article&url=https%3A%2F%2Fhelp.aliyun.com%2Fproduct%2F50980.html)。

> **Funcraft**：Funcraft 是一个用于支持 Serverless 应用部署的工具，能帮助您便捷地管理函数计算、API 网关、日志服务等资源。它通过一个资源配置文件（template.yml），协助您进行开发、构建、部署操作。Fun 的更多文档[参考](https://github.com/aliyun/fun)。

> **spring-petclinic**：[PetClinic](https://github.com/spring-projects/spring-petclinic) 是一个 Spring Boot 、Spring MVC 和 Spring Data 结合使用的示例项目，是学习 Spring Boot 经典案例。

![](https://data-analysis.cn-shanghai.log.aliyuncs.com/logstores/article-logs/track_ua.gif?APIVersion=0.6.0&title=%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%20Spring%20PetClinic%20%E5%88%B0%E5%87%BD%E6%95%B0%E8%AE%A1%E7%AE%97%E5%B9%B3%E5%8F%B0&author=%E5%80%9A%E8%B4%A4&src=article)
![](https://img.alicdn.com/tfs/TB1fc0BspP7gK0jSZFjXXc5aXXa-518-316.png)

Spring 框架是由一些小而美的 Java 框架以松散耦合的方式集成在一起。这些 Java 框架可以独立或者集成使用以构建许多不同类型的工业级应用程序。PetClinic 示例应用程序是为了说明如何使用 Spring 应用程序框架来构建简单且功能强大的面向数据库的应用程序。它演示了 Spring 核心功能用法。

使用控制反转和 MVC 的 Web 表示层，基于 JavaBeans 的应用程序配置，通过 JDBC，Hibernate 或 JPA 进行数据库访问，基于 JMX 声明式事务管理的应用程序监视，使用 AOP 数据验证来支持但不依赖于表示层的 Spring 框架提供了大量有用的基础结构，以简化应用程序开发工作。

![](https://img.alicdn.com/tfs/TB11ZBEsuL2gK0jSZPhXXahvXXa-645-472.png)

本应用模板使用函数计算的 [Custom 运行时](https://statistics.functioncompute.com/?title=%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%20Spring%20PetClinic%20%E5%88%B0%E5%87%BD%E6%95%B0%E8%AE%A1%E7%AE%97%E5%B9%B3%E5%8F%B0&author=%E5%80%9A%E8%B4%A4&src=article&url=https%3A%2F%2Fhelp.aliyun.com%2Fdocument_detail%2F132044.html)和 [RDS-MySQL 云服务](https://cn.aliyun.com/product/rds/mysql)作为 Spring Boot 应用的运行环境。借助于[资源编排服务（ROS）](https://cn.aliyun.com/product/ros)的能力，该模板会自动创建 VPC、VSwitch、SecurityGroup、RDS 和绑定了 HTTP Trigger 的函数，以及绑定到 HTTP 函数的自定义域名，并自动配置好这些服务，以达到迅速上线开箱即用的效果。

注意：

1. 需要提供一个域名（支持二级域名），如果部署在国内 Region 该域名需要在阿里云备案，然后把域名的 CNAME 记录指向 `12345.cn-shanghai.fc.aliyuncs.com`，其中 `12345` 换成您的 AccountID，如果是在国外 Region 可以免去备案环节，[请查看更多参考](https://help.aliyun.com/document_detail/90722.html)
2. 模板创建的 [RDS-MySQL 云服务](https://cn.aliyun.com/product/rds/mysql)选用了最便宜的按量付费实例，费用大约为：￥0.236/小时，使用前需要确保账户有 100 元的余额，并且试用完成以后建议通过 [ROS 控制台](https://rosnext.console.aliyun.com/)删除该应用，以免产生超出预期的费用。

## 快速开始

下面我们借助于函数计算的应用中心，快速地将 Spring PetClinic 快速部署到函数计算平台。

1. 打开函数计算 [Spring PetClinic 应用详情页](https://statistics.functioncompute.com/?title=%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%20Spring%20PetClinic%20%E5%88%B0%E5%87%BD%E6%95%B0%E8%AE%A1%E7%AE%97%E5%B9%B3%E5%8F%B0&author=%E5%80%9A%E8%B4%A4&src=article&url=https%3A%2F%2Ffc.console.aliyun.com%2Ffc%2Fapplications%2Fcn-hongkong%2Ftemplate%2FSpring-PetClinic%23intro)。如果您尚未开通函数计算服务可能需要先，开通服务是免费的，另外函数计算有每月免费额度，试用服务不会产生费用。
   ![](https://img.alicdn.com/tfs/TB1yw8Vsxn1gK0jSZKPXXXvUXXa-1071-680.png)
2. 滚动到 [Spring PetClinic 应用详情页](https://statistics.functioncompute.com/?title=%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%20Spring%20PetClinic%20%E5%88%B0%E5%87%BD%E6%95%B0%E8%AE%A1%E7%AE%97%E5%B9%B3%E5%8F%B0&author=%E5%80%9A%E8%B4%A4&src=article&url=https%3A%2F%2Ffc.console.aliyun.com%2Ffc%2Fapplications%2Fcn-hongkong%2Ftemplate%2FSpring-PetClinic%23intro)的最底部，点击“立即部署”按钮。
   ![](https://img.alicdn.com/tfs/TB10ylYsy_1gK0jSZFqXXcpaXXa-1071-680.png)
3. 填写应用名称和域名，其中域名需要先去设定 DNS 的 CNAME 记录，然后点击“部署”按钮。
   ![](https://img.alicdn.com/tfs/TB1eGB2sAY2gK0jSZFgXXc5OFXa-1071-1103.png)
4. 稍等片刻，等到部署成功以后，拷贝 URL 网址。
   ![](https://img.alicdn.com/tfs/TB1Zy0YsEH1gK0jSZSyXXXtlpXa-1071-707.png)
5. 在浏览器中打开上面拷贝的网址
   ![](https://img.alicdn.com/tfs/TB12C4YsxD1gK0jSZFsXXbldVXa-1071-707.png)

## 工作原理

本示例中，我们打算使用函数计算的 [Custom 运行时](https://statistics.functioncompute.com/?title=%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%20Spring%20PetClinic%20%E5%88%B0%E5%87%BD%E6%95%B0%E8%AE%A1%E7%AE%97%E5%B9%B3%E5%8F%B0&author=%E5%80%9A%E8%B4%A4&src=article&url=https%3A%2F%2Fhelp.aliyun.com%2Fdocument_detail%2F132044.html) 来移植 Petclinic 项目。顾名思义， Custom Runtime 就是自定义的执行环境， 用户基于 Custom Runtime 可以完成以下目标：

* 可以随心所欲持定制个性化语言执行环境（例如 Golang、Lua、Ruby）以及各种语言的小版本（例如 Python3.7、Nodejs12 )等，打造属于自己的自定义 Runtime
* 现有的 Web 应用或基于传统开发 Web 项目基本不用做任何改造，即可将项目一键迁移到函数计算平台

该应用的架构图如下：

![](https://img.alicdn.com/tfs/TB1EbdXsCf2gK0jSZFPXXXsopXa-1029-645.png)

## 定制化开发

### 依赖工具

本项目是在 MacOS 下开发的，涉及到的工具是平台无关的，对于 Linux 和 Windows 桌面系统应该也同样适用。在开始本例之前请确保如下工具已经正确的安装，更新到最新版本，并进行正确的配置。

* [Docker](https://www.docker.com/)
* [Funcraft](https://github.com/aliyun/fun)

Fun 工具依赖于 docker 来模拟本地环境。

对于 MacOS 用户可以使用 [homebrew](https://brew.sh/) 进行安装：

```bash
brew cask install docker
brew tap vangie/formula
brew install fun
```

Windows 和 Linux 用户安装请参考：

1. https://github.com/aliyun/fun/blob/master/docs/usage/installation.md

安装好后，记得先执行 `fun config` 初始化一下配置。

**注意**, 如果你已经安装过了 funcraft，确保 funcraft 的版本在 3.2.1 以上。

```bash
$ fun --version
3.2.1
```

### 初始化

```bash
git clone https://github.com/awesome-fc/spring-petclinic-for-serverless
cd spring-petclinic-for-serverless
```

### 编译打包

```bash
mvn package -Dmaven.test.skip=true
```

### 本地运行

```bash
MYSQL_HOST=localhost MYSQL_PORT=3306 MYSQL_DBNAME=petclinic MYSQL_USER=root MYSQL_PASSWORD= ./bootstrap
```

请在运行上述命令前启动好本地的 MySQL 数据库，并将上述 `MYSQL_*` 的值替换为您本地 MySQL 数据库的配置。

### 部署

```bash
make deploy
```

为了获得更好的开发体验，建议安装 [Aliyun Serverless VSCode Extension](https://marketplace.visualstudio.com/items?itemName=aliyun.aliyun-serverless)

## 参考链接

1. [Serverless 实战 —— 移植 spring-petclinic 到函数计算](https://statistics.functioncompute.com/?title=%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%20Spring%20PetClinic%20%E5%88%B0%E5%87%BD%E6%95%B0%E8%AE%A1%E7%AE%97%E5%B9%B3%E5%8F%B0&author=%E5%80%9A%E8%B4%A4&src=article&url=https%3A%2F%2Fyq.aliyun.com%2Farticles%2F724662)
2. [Funcraft](https://github.com/alibaba/funcraft)
3. [Aliyun Serverless VSCode Extension](https://github.com/alibaba/serverless-vscode)
