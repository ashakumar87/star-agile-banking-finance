resource "aws_instance" "test-server" {
  ami = "ami-0c614dee691cbbf37"
  instance_type = "t2.micro"
  key_name = "sample"
  vpc_security_group_ids = ["sg-03c380392b8d58f6f"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./sample.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/BankingProject/terraform-files/ansibleplaybook.yml"
     }
  }
