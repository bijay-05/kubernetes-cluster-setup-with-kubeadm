module "cluster_vpc" {
  source = "./modules/vpc"

}

module "instance_ssm_role" {
  source = "./modules/iam"

}

module "instance_sg" {
  source = "./modules/securitygroup"
  vpc_id = module.cluster_vpc.vpc_id

}

module "instances" {
  source = "./modules/compute"

  security_groups_id = [module.instance_sg.instance_ssh_sg_id, module.instance_sg.vpc_internal_sg_id]
  ssm_instance_profile_name = module.instance_ssm_role.ssm_instance_profile_name

  launch_template_id = var.launch_template_id
  launch_template_version = var.launch_template_version

  nodes = {
    "master" = {
      name = "master",
      instance_type = "c7i-flex.large",
      public = true
      subnet_id = module.cluster_vpc.public_subnets_id[1]
      custom_script_path = "./setup.sh"
      public_key = ""
    },
    "workera" = {
      name = "workera",
      instance_type = "t3.small",
      public = false
      subnet_id = module.cluster_vpc.private_subnets_id[1]
      custom_script_path = "./setup-worker.sh"
      public_key = ""
    },
    "workerb" = {
      name = "workerb",
      instance_type = "t3.small",
      public = false
      subnet_id = module.cluster_vpc.private_subnets_id[1]
      custom_script_path = "./setup-worker.sh"
      public_key = ""
    }
  }
}