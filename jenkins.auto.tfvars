name                      = "bhhan"
environment               = "dev"
aws_region                = "ap-northeast-2"
vpc_cidr                  = "192.168.0.0/16"
azs                       = ["ap-northeast-2a", "ap-northeast-2b"]
public_subnet_cidr        = ["192.168.1.0/24", "192.168.2.0/24"]
enable_single_nat_gateway = false
ami                       = "ami-0221383823221c3ce"
instance_type             = "t3.medium"
instance_key_name         = "bhhan-instance-key"

jenkins_instance_values = [
  {
    name            = "master"
    efs_mount_point = "var/lib/jenkins"
    master          = true
  },
  {
    name            = "slave1"
    efs_mount_point = ""
    master          = false
  },
  {
    name            = "slave2"
    efs_mount_point = ""
    master          = false
  }
]
