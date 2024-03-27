terraform {

      required_version = "~>1.7.2"
      required_providers {
        jinja = {
           source = "NikolaLohinski/jinja"
           version = ">=2.2.0"
             }
           }
 }

# Create a security group for instances 
resource "aws_security_group" "ssh_group_access" {
  name        = "ssh_group_access"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from any IP address
  }
}

# Prepare jinja templates
locals {
  yaml_file = yamldecode(file("${path.module}/data.yaml"))
}


# Prepare jinja template for disk creation block
data "jinja_template" "disk_create_attach" {
  template = "./templates/disk_create_attach.j2"
  context {

    type = "yaml"
    data = yamlencode({ 
      instances = local.yaml_file.instances
      settings = local.yaml_file.settings
      letters = local.yaml_file.letters
    })
  }
}

resource "aws_instance" "ec2_instances" {
  for_each = {for k, v in yamldecode(data.jinja_template.disk_create_attach.result) : k => v }
  
  ami           = each.value.ami
  instance_type = each.value.type
  vpc_security_group_ids = [aws_security_group.ssh_group_access.id]
  key_name =  each.value.key
  associate_public_ip_address = true
  tags = {
    Name = each.value.name
  }  
  dynamic "ebs_block_device"{
    for_each = each.value.block_devices
    content {
      volume_size = ebs_block_device.value.size
      device_name = ebs_block_device.value.dev_name[0]
    }
  }
  
}

locals {
  instances = aws_instance.ec2_instances
}

data "jinja_template" "inventory_template" {
  template = "./templates/inventory_template.j2"
  context {
    type = "yaml"
    data = yamlencode({ 
      instances = local.instances
    })
  }
}

resource "null_resource" "write_inventory_file" {
  triggers = {
    inventory_content = data.jinja_template.inventory_template.result
  }

  provisioner "local-exec" {
    command = <<EOT
echo "${data.jinja_template.inventory_template.result}" > inventory.ini
EOT
  }
}

