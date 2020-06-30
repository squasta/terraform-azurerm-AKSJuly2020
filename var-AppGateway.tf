#  Application Gateway (used for AGIC) Name
variable "app_gw_name" {
  type    = string
  default = "agic-appgw-stan"
}

# Application Gateway (used for AGIC) SKU
# cf https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-autoscaling-zone-redundant
# cf https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html 
# Possible values : Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2
variable "app_gw_sku" {
  type    = string
  default = "Standard_v2"
}

# Application Gateway (used for AGIC) tier
# tier - (Required) The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2.
# Possible values : Standard, Standard_v2, WAF and WAF_v2
# cf https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html 
variable "app_gw_tier" {
  type    = string
  default = "Standard_v2"
}

# Application Gateway (used for AGIC) capacity
# possible value :  1 to 125 for a V2 SKU
variable "app_gw_capacity" {
  type    = number
  default = 2
}

# Frontend port name
variable "frontend_port_name" {
  type    = string
  default = "front-end-stan1"
}

# frontend_ip_configuration_name
variable "frontend_ip_configuration_name" {
  type    = string
  default = "frontend_ip_configuration_stan1"
}

# backend_address_pool_name
variable "backend_address_pool_name" {
  type    = string
  default = "backend_address_pool_name_stan1"
}

# http_setting_name
variable "http_setting_name" {
  type    = string
  default = "http_setting_name_stan1"
}

# listener_name
variable "listener_name" {
  type    = string
  default = "listener_name_stan1"
}

# request_routing_rule_name
variable "request_routing_rule_name" {
  type    = string
  default = "request_routing_rule_name_stan1"
}
