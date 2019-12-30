## Introduction

[Spring Petclinic](https://github.com/spring-projects/spring-petclinic) is a sample project which integrated of Spring Boot, Spring MVC, and Spring Data. It is a classic case of learning Spring Boot.

This application template uses the custom runtime of Function Compute and the RDS-MySQL cloud service as the Spring Boot application's running environment.With the help of ROS, this template will automatically create VPC, VSwitch, SecurityGroup, RDS, and functions bound to HTTP Trigger, as well as custom domain names bound to HTTP functions, and automatically configure these services to achieve rapid deployment and Out of the box.

note:

1. Need to provide a domain (support second-level domain), then the CNAME record of the domain name is pointed to `12345.cn-shanghai.fc.aliyuncs.com`, where `12345` is replaced Into your AccountID.
2. The MySQL service created by the template uses the cheapest pay-as-you-go instance. The cost is about RMB 0.236 per hour. Before using it, you need to ensure that your account has a balance of 100 RMB. After the experiment, it is recommended to delete the application through the [ROS console](https://rosnext.console.aliyun.com/) to avoid excessive costs.



![](https://img.alicdn.com/tfs/TB1MBzgr7T2gK0jSZFkXXcIQFXa-2084-1334.png)

 &nbsp;&nbsp;

## Architecture & Design

In this example, we intend to use the Custom Runtime of Function Compute to port the Petclinic project. As the name suggests, Custom Runtime is a custom execution environment. Based on Custom Runtime, users can complete the following goals:

* You can customize your own customized language execution environment (such as Golang, Lua, Ruby) and small versions of various languages ​​(such as Python3.7, Nodejs12), etc. to create your own custom Runtime.
* Existing Web applications or traditionally-developed Web projects can be migrated to a function computing platform without any modification

The architecture diagram of the application is as follows:

![](https://img.alicdn.com/tfs/TB1UM.Hr4D1gK0jSZFsXXbldVXa-974-450.png)

 &nbsp;&nbsp;

Project source code: https://github.com/vangie/spring-petclinic-for-serverless