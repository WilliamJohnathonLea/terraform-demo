#! /bin/sh
echo 'EC2 Bootstrap'
echo 'Updating repositories'
sudo yum update -y
echo 'Installing Docker'
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user