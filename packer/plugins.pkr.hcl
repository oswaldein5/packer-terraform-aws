// Definition of plugins required by Packer

packer {
  required_plugins {
    amazon = {
        source  = "github.com/hashicorp/amazon"
        version = "~> 1.2.8"
    }
  }
}