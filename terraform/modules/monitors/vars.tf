variable "tags" {
  type = map(string)
}
variable "alarm_name" {
  type = list(string)
}
variable "comparison_operator" {
  type = string
}
variable "evaluation_periods" {
  type = list(number)
}

variable "metric_name" {
  type = list(string)
}

variable "namespace" {
  type = string
}

variable "period" {
  type = list(number)
}

variable "statistic" {
  type = string
}

variable "threshold" {
  type = list(number)
}

variable "alarm_description" {
  type = string
}
