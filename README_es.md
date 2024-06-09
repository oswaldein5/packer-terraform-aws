### 1. Generar y Desplegar Imágenes AMI usando **Packer** en el proveedor de nube **AWS**.
### 2. Con **Terraform** generar Instancias EC2 basadas en las imágenes de Packer, adicional configurar un Balanceador de Carga y una Zona privada lab.test para DNS en el proveedor de nube **AWS**.

---
![Diagrama](/imgs/Diagram.jpg)
---

#### - Packer
   - [Código fuente](packer/main.pkr.hcl)
   - [Files](packer/files/)
   - [Scripts](packer/scripts/)

#### - Terraform
   - [Código fuente](terraform/main.tf)
   - Módulos:
     - [VPC](terraform/modules/vpc/)
     - [Grupos de Seguridad](terraform/modules/sgs/)
     - [Instancias EC2](terraform/modules/ec2s/)
     - [Balanceador de Carga de Aplicaciones](terraform/modules/alb/)
     - [DNS](terraform/modules/dns/)
