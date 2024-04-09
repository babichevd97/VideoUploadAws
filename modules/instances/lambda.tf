#----------------------------------------------------------
# Lambda
#----------------------------------------------------------
data "archive_file" "py_code" {
  type        = "zip"
  source_dir  = "../src"
  output_path = "../lambda_handler.zip"
}

resource "aws_lambda_function" "lambda_handler" { //Main lambda function
  function_name    = "stitchVideo"
  handler          = "lambda.stitch_video"
  runtime          = "python3.9"
  filename         = data.archive_file.py_code.output_path
  source_code_hash = data.archive_file.py_code.output_base64sha256
  role             = aws_iam_role.iam_role.arn
}

#Lambda Destination
resource "aws_lambda_function_event_invoke_config" "lambda_sqs_destination" {
  function_name = aws_lambda_function.lambda_handler.arn
  destination_config {
    on_success {
      destination = aws_sqs_queue.complete_upload_queue.arn
    }
  }
}

#Lambda SQS Trigger
resource "aws_lambda_event_source_mapping" "lambda_sqs_trigger" {
  event_source_arn = aws_sqs_queue.start_upload_queue.arn
  function_name    = aws_lambda_function.lambda_handler.arn
  depends_on       = [aws_sqs_queue.start_upload_queue]

}