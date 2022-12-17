terraform {

}

variable "planet" {
  type    = list(any)
  default = ["Earth", "Mars", "Venus"]
}
variable "plans" {
  type = map(any)
  default = {
    "Earth" = "1"
    "Mars"  = "2"
    "Venus" = "3"
  }
}

variable "plan_object" {
  type = object({
    name   = string
    number = number
  })
  default = {
    name   = "Earth"
    number = 1
  }
}

variable "random" {
  type    = tuple([string, number])
  default = ["Earth", 1]
}

