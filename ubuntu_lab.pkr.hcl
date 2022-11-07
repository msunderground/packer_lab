packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu_lab"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami_filter {
    filters = {
      name  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username  = "ubuntu"
}
build {
  sources = [
    "source.amazon-ebs.ubuntu"
    ]
  provisioner "file" {
    source      = "./Scripts/packer_key.pub"
    destination = "~/.ssh/"
  }
  provisioner "shell" {
    inline = ["cat ~/.ssh/packer_key.pub >> ~/.ssh/authorized_keys"]
  }
  provisioner "shell" {
    script = "Scripts/Docker_install.sh"
  }
}