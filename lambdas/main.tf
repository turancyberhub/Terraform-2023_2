data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda_12345"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

#compress/zip .py file to upload into lambda
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "delete_txt_files.py"
  output_path = "delete_txt_files.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda.output_path
  function_name = "delete_txt_files"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "delete_txt_files.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.11"

  environment {
    variables = {
      S3_BUCKET_NAME = "aws-cli-bucket-tch-12345"
    }
  }
}
