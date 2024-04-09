#----------------------------------------------------------
# Terraform main file. Includes all dependent modules
#----------------------------------------------------------
provider "aws" {                                          
  shared_credentials_files = ["~/.aws/credentials"]           //Our credentials file
  region     = "eu-central-1"                                 //Set region

}

module "aws_instances" { //Какой модуль используем + его название
  source = "../modules/instances" //Исходники на локальной тачке 
}