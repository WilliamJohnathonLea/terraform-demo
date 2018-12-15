provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}
data "aws_route53_zone" "universauth_zone" {
    name = "${var.route53_hz_name}"
}
resource "aws_route53_record" "mongo_record" {
    zone_id = "${data.aws_route53_zone.universauth_zone.zone_id}"
    name = "mongo.${data.aws_route53_zone.universauth_zone.name}"
    type = "A"
    ttl = "300"
    records = ["${aws_eip.example_public_ip.public_ip}"]
}
resource "aws_key_pair" "example_ssh_key" {
    key_name = "developer_key"
    public_key = "${file("keys/developer_key.pub")}"
}
resource "aws_eip" "example_public_ip" {
    instance = "${aws_instance.example.id}"
}
resource "aws_instance" "example" {
    ami = "ami-01419b804382064e4"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.example_ssh_key.key_name}"

    provisioner "remote-exec" {
        script = "${var.example_bootstrap_script}"
        connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("keys/developer_key")}"
        }
    }
}
