### 1. Generate and Deploy AMI Images using **Packer** in **AWS** cloud provider.
### 2. With **Terraform** generate EC2 Instances based on the Packer images, additional configure a Load Balancer and a private lab.test Zone for DNS on **AWS** cloud provider.

---
![Diagram](/imgs/Diagram.jpg)
---

#### - Packer
   - [Main program](packer/main.pkr.hcl)
   - [Files](packer/files/)
   - [Scripts](packer/scripts/)

#### - Terraform
   - [Main program](terraform/main.tf)
   - Modules:
     - [VPC](terraform/modules/vpc/)
     - [Security Groups](terraform/modules/sgs/)
     - [EC2 Instances](terraform/modules/ec2s/)
     - [Application Load Balancer](terraform/modules/alb/)
     - [DNS](terraform/modules/dns/)
