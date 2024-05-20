resource "aws_key_pair" "subhodeep_test" {
  key_name   = "subhodeep-test"
  public_key = file("/Users/subhodeepganguly/Desktop/Educosys_Course/terraform-ec2/subhodeep_test_new.pub")
}


resource "aws_instance" "web" {
  count         = 3
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.subhodeep_test.key_name
  subnet_id     = var.subnet_id // Add this line
  security_groups = [var.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "web-instance-${count.index}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y", # or "sudo apt-get update -y" for Ubuntu/Debian systems
      "sudo yum install -y java-1.8.0-openjdk", # or appropriate package for your system
      "export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))",
      "export JRE_HOME=$JAVA_HOME/jre",
      "export PATH=$PATH:$JAVA_HOME/bin",
      "echo 'export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))' | sudo tee -a /etc/profile",
      "echo 'export JRE_HOME=$JAVA_HOME/jre' | sudo tee -a /etc/profile",
      "echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile",
      "wget http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.tar.gz",
      "tar xzvf apache-tomcat-9.0.37.tar.gz",
      "apache-tomcat-9.0.37/bin/startup.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/Users/subhodeepganguly/Desktop/Educosys_Course/terraform-ec2/subhodeep_test.pem")
      host        = self.public_ip
    }
  }
}
