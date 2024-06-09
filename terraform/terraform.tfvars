#* Assignment of value to variables in the global context

virginia_cidr        = "10.0.0.0/16"
public_subnets_cidr  = ["10.0.1.0/28", "10.0.2.0/28"]
private_subnets_cidr = ["10.0.3.0/28", "10.0.4.0/28", "10.0.5.0/28"]
private_domain       = "lab.test"

tags = {
  "region"      = "virginia"
  "env"         = "dev"
  "contributor" = "Oswaldo Solano"
  "IAC"         = "Terraform"
  "IAC-v"       = "1.8.2"
  "project"     = "mean-lab"
}
