resource "aws_s3_bucket" "devops_s3" {
  bucket = var.bucket_name
  tags = {
    Name  = "devops-bucket"
    Owner = "Vakhob"
  }
}

resource "aws_s3_object" "devops_bucket_object" {
  bucket = aws_s3_bucket.devops_s3.id
  source = "terraform.tfstate"
  key    = "terraform/tfstate/terraform.tfstate"
}
