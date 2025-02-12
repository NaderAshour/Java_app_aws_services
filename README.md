## 📌 Project Overview
This project demonstrates how to deploy a *multi-tier Java web application* using *AWS cloud-native services, eliminating the need for traditional software installations. By leveraging **Amazon EC2, RDS, ElastiCache, Elastic Load Balancing, and SQS, we automate the entire infrastructure using **shell scripts* and enforce security with well-defined *security groups*.

## 🎯 Purpose
The goal of this project is to:
- Deploy a *highly available, scalable, and secure* Java web application on AWS.
- Automate the provisioning and configuration of AWS services using *shell scripts*.
- Implement *security best practices* by assigning specific security groups to each service.
- Provide a *real-world example* for cloud-based development and automation.

## 🔧 AWS Services & Tools Used
| Service | Purpose |
|---------|---------|
| *Amazon EC2* | Hosts the Tomcat-based Java web application |
| *Amazon RDS* | Manages the relational database securely |
| *Amazon ElastiCache* | Caching layer to improve performance |
| *AWS Elastic Load Balancer (ELB)* | Distributes traffic across multiple EC2 instances |
| *AWS SQS* | Handles message queuing for async communication |
| *AWS CLI* | Automates AWS service provisioning |
| *Maven & Git* | Used for Java build automation & version control |

## 🏗️ Architecture
The architecture consists of multiple AWS services interacting securely:
- *EC2 Instance (Application Server)* – Runs Tomcat with the Java web app.
- *Amazon RDS (Database Layer)* – Stores application data securely.
- *Amazon ElastiCache (Caching Layer)* – Speeds up data retrieval.
- *AWS Elastic Load Balancer* – Balances incoming traffic across EC2 instances.
- *AWS SQS (Message Queue)* – Ensures smooth async communication.

![Project Architecture](./architecture.gif)![2025-02-1217-26-21online-video-cutter com-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/2e45be72-e98f-4138-80e8-c3f195d1d9bb)



## 📌 Setup Instructions

### 1️⃣ Prerequisites
Ensure you have:
- *AWS Account* & *IAM Permissions* for creating resources.
- *AWS CLI installed* → [Download AWS CLI](https://aws.amazon.com/cli/)
- *EC2 Key Pair* for SSH access → [AWS Key Pair Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

### 2️⃣ Clone This Repository
sh
$ git clone https://github.com/NaderAshour/Java_app_aws_services.git



### 3️⃣ Run the Setup Scripts
#### 🏗️ *Step 1: Launch EC2 Instance (With Amazon Linux 2) & Install Tomcat*
sh
$ tomcat_setup (1).sh

- This script creates an *EC2 instance, installs **Java & Tomcat, and create database and initialize it with accounts_backup.db




## 🔥 Security Best Practices
✅ *Each AWS service has its own security group* with *minimal permissions*:
- *EC2* – Allows *HTTP (80) & SSH (22)* only.
- *RDS* – Accepts connections only from *EC2 security group*.
- *ElastiCache* – Restricted to *EC2 security group*.
- *SQS* – Accessible *only by EC2*.
- *Load Balancer* – Publicly accessible but routes only to *healthy EC2 instances*.


## 👨‍💻 Contributors
- *Mohamed Elweza*


---

📌 *Follow this repository for updates!*
✅ If you found this useful, don't forget to *star ⭐ the repo*!

💬 Feel free to open issues or contribute to improve this setup!
