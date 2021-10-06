## Workload variables
variable "description" {
  type = string
  description = "(Required) Azure workload description"
}

variable "workload_acronym" {
  type = string
  description = "(Required) Santander project acronym"
}

## Networking
variable "vnet_rsg_name" {
  type = string
  description = "(Required) Virtual network resource group name"
}

variable "vnet_name" {
  type = string
  description = "(Required) Virtual network name"
}

variable "snet_name" {
  type = string
  description = "(Required) Subnet name"
}

## Kubernetes service
variable "aks_name" {
  type = string
  description = "(Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
}

variable "dns_prefix" {
  type = string
  description = "(Required) Specifies the DNS prefix to use with private clusters."
}

variable "nodepool_name" {
  type = string
  description = "(Optional) Node pool name. Default: system"
  default = "system"
}

variable "node_count" {
  type = number
  default = 1
}

variable "enable_autoscaling" {
  type = bool
  description = "(Optional) Should the Kubernetes Auto Scaler be enabled for this Node Pool? Defaults to true."
  default = true
}

variable "vm_size" {
  type = string
  description = "(Required) Node size. Default: Standard_D2_v2"
  default = "Standard_D2_v2"
}

variable "outbound_type" {
  type = string
  description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to userDefinedRouting"
  default = "userDefinedRouting"
}

variable "network_policy" {
  type = string
  description = "(Optional) Sets up network policy to be used. Default: calico"
  default = "calico"
}