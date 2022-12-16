terraform {

}


provider "aws" {
  # Configuration options
  region = "us-east-1"
}

module "apache" {
  source        = ".//terraform-aws-apache-example"
  vpc_id        = "vpc-0af72937237702351"
  instance_type = "t2.micro"
  public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ9W674jBsh2tEI10Xt/7YQAvzWbvACxg2lAi1pQB7qmmTlg3xqbS8eHYXlRWYRocUln/2s4aa/etWFBXDSJgmOt1tJ9UTwNJMxT6IaULE3T1/gnavcV3oQYtBmijbDXdP9/MB84i1nP2g+xQnTc4fpUyzSzVrPEw71M+EWfr6WOrQI8bH8k6wTsTX0WKXP0SAtLXTKvbgW6LNx+SY9j7FJ3qagNAxqb6b0XBe5fityO4e2buGOaft8Rh5yUQAhJbPTN/ha6tNmUfNP1GEFmyAWtmdV5+OZYRdoNP8lBM3t9eD6QJGJRI9JtKcbNHw27ZPunjWsqx05EjmjLixYaeY0TlLMl1PkmrDAI7hndw/d7xxK9MqALUbOBaFH8Cwm3i4wd90Ppy10zLRmbPW65kb4FenCUkAiF8L4HozEslJH0M9abrnmP1FVinGh1+YuvD8g5MWCajKwnIJzG8PcWE1VutGTG1LXohjMclOVJSWCHHIV46q8M8b9q/g+xK6Lws= arnab@arnab-HP-Pavilion-x360-Convertible-14-dh1xxx"
  server_name = "apache-server"
}

output "name" {
  value = module.apache.public_ip
}
  
