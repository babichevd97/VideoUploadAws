#----------------------------------------------------------
# Provider init
#----------------------------------------------------------

provider "aws" {                                          
  shared_credentials_files = ["~/.aws/credentials"]  //Our credentials file. AWS-CLI should be configure
  region     = "eu-central-1"                        //Set region

}

#----------------------------------------------------------
# S3
#----------------------------------------------------------
resource "aws_s3_bucket" "bucket_chunks" {
  bucket = "dev-bucket-upload-video-test"  //Bucket name
  tags = {
    Name        = "Video Chunks Bucket"
    Owner   = "Denis Babichev"
    Environment = "Dev"
    Project = "Video-Upload"
  }
  force_destroy = true
}

resource "aws_s3_object" "chunks_dir_object" {
  bucket = aws_s3_bucket.bucket_chunks.id
  key    = "chunks/directory/" //Directory for chunks
  acl    = "public-read-write" //For easier showcase
}

resource "aws_s3_object" "files_dir_object" {
  bucket = aws_s3_bucket.bucket_chunks.id
  key    = "files/stitched/" //Directory for stitched file
  acl    = "public-read-write" //For easier showcase
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.bucket_chunks.id
  rule {
    object_ownership = "BucketOwnerPreferred" 
  }
}

resource "aws_s3_bucket_public_access_block" "access" { 
  bucket = aws_s3_bucket.bucket_chunks.id

  //For easier showcase
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.access,
  ]

  bucket = aws_s3_bucket.bucket_chunks.id
  acl    = "public-read-write" //For easier showcase
}
