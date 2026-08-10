variable "security_groups_id" {
  type = list(string)
  description = "The list of security groups ID"
}

variable "launch_template_id" {
  type = string
  default = "lt-0"
}

variable "launch_template_version" {
  type = number
  default = 1
}

variable "ssm_instance_profile_name" {
  type = string
  description = "SSM Instance Profile Name"
}

variable "nodes" {
  type = map(object({
    name = string
    instance_type = string
    public = bool
    subnet_id = string
    public_key = string
    custom_script_path = string

  }))
}