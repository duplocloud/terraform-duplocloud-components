variable "tenant_id" {
  type = string
}
variable "prefix" {
  default = "apps"
  type    = string
}
variable "eks_version" {
  type    = string
  default = "1.30"
}
variable "az_list" {
  default     = ["a", "b"]
  type        = list(string)
  description = "The letter at the end of the zone"
}
variable "base_ami_name" {
  default = "amazon-eks-node"
  type    = string
}
variable "capacity" {
  default = "t3.medium"
  type    = string
}
variable "instance_count" {
  default = 1
  type    = number
}
variable "min_instance_count" {
  default = 1
  type    = number
}
variable "max_instance_count" {
  default = 3
  type    = number
}
variable "os_disk_size" {
  default = 20
  type    = number
}
variable "is_ebs_optimized" {
  default = false
  type    = bool
}
variable "encrypt_disk" {
  default = false
  type    = bool
}
variable "minion_tags" {
  type        = map(string)
  description = "Tags to apply to the Duplo Minions"
  default     = {}
}
variable "metadata" {
  type        = map(string)
  description = "Metadata to apply to the Duplo Minions"
  default     = {}
}
variable "asg_taints" {
  description = "List of taints to apply on the ASG nodes. Each taint requires a key, value, and effect (NoSchedule, PreferNoSchedule, or NoExecute)."
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = [
    {
      key    = "tk1"
      value  = "tv2"
      effect = "NoSchedule"
    }
  ]
}
variable "asg_ami" {
  default     = null
  description = "Set AMI to static value"
  type        = string
}
variable "use_spot_instances" {
  default = false
  type    = bool
}
variable "max_spot_price" {
  default     = null
  description = "Maximum price to pay for a spot instance in dollars per unit hour, such as 0.40"
  type        = string
}
variable "can_scale_from_zero" {
  default = false
  type    = bool
}
# Used on jan_2025 portal release and newer only
variable "min_healthy_percentage" {
  default     = 90
  description = "Minimum percentage of healthy hosts during Instance Refresh"
  type        = number
}
variable "max_healthy_percentage" {
  default     = 100
  description = "Maximum percentage of healthy hosts during Instance Refresh"
  type        = number
}
variable "instance_warmup_seconds" {
  default     = 300
  description = "Time in seconds to wait for Instance after it becomes available"
  type        = number
}
variable "use_auto_refresh" {
  default     = true
  description = "Automatically refresh instances on AMI/Capacity changes to ASG"
  type        = bool
}
