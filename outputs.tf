output "eip_list" {
  value = [for ip in aws_eip.instance_eip: ip.public_ip]
}
