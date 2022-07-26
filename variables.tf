variable "filter_str" {
  type = string
}

variable "env" {
  description = "This refers to the environment or which stage of deployment this monitor is checking. Good values are prd, acc, tst, dev..."
  type        = string
}

variable "service" {
  description = "Service name of what you're monitoring. This also sets the service:<service> tag on the monitor"
  type        = string
  default     = ""
}

variable "service_display_name" {
  description = "Readable version of service name of what you're monitoring."
  type        = string
  default     = null
}

variable "notification_channel" {
  description = "Channel to which datadog sends alerts, will be overridden by alerting_enabled if that's set to false"
  type        = string
  default     = ""
}

variable "additional_tags" {
  description = "Additional tags to set on the monitor. Good tagging can be hard but very useful to make cross sections of the environment. Datadog has a few default tags. https://docs.datadoghq.com/getting_started/tagging/ is a good place to start reading about tags"
  type        = list(string)
  default     = []
}

variable "locked" {
  description = "Makes sure only the creator or admin can modify the monitor"
  type        = bool
  default     = true
}

variable "name_prefix" {
  description = "Can be used to prefix to the Monitor name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Can be used to suffix to the Monitor name"
  type        = string
  default     = ""
}

variable "filter_str_concatenation" {
  description = "If you use an IN expression you need to switch from , to AND"
  default     = ","
}

variable "priority_offset" {
  description = "For non production workloads we can +1 on the priorities"
  default     = 0
}
