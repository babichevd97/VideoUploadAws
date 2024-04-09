#----------------------------------------------------------
# Policies/Rules and ACL
#----------------------------------------------------------
resource "aws_iam_role" "iam_role" {
  name = "lambda-iam-role"
  assume_role_policy = <<EOF
{
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
    }
    ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_sqs_permissions" {
  name   = "lambda_sqs_permissions"
  role   = aws_iam_role.iam_role.name
  policy = jsonencode({
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.complete_upload_queue.arn
      }
    ]
  })
}

#Attachment for S3 Read Access
resource "aws_iam_role_policy_attachment" "lambda_s3_read_access" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

#Attachment for Lambda execution
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  policy_arn             = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role                   = aws_iam_role.iam_role.name
}

#Attachment for Lambda sqs execution
resource "aws_iam_role_policy_attachment" "lambda_basic_sqs_queue_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
  role       = aws_iam_role.iam_role.name
}