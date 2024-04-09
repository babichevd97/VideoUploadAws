#----------------------------------------------------------
# SQS
#----------------------------------------------------------
resource "aws_sqs_queue" "start_upload_queue" {
  name = "start_upload" # Queue for starting upload
}

resource "aws_sqs_queue" "complete_upload_queue" {
  name = "complete_upload" # Queue for completing upload
}