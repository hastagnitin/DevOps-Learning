terraform {
  backend "s3" {
    bucket         = "my-devops-state-bucket" 
    key            = "terraform/task2/state.tfstate"
    region         = "ap-south-1"
    
  }
}