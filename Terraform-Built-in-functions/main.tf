terraform {
  
}

variable "str" {
  type = string
  default = "!Hello,World"
}
variable "str1" {
  type = string
  default = ""
}

variable "items" {
  type = list
    default = ["a", "b", "c", "null"]
}
variable "stuff" {
  type = map
    default = {
        a = "apple"
        b = "banana"
        c = "carrot"
    }
}