resource "aws_dynamodb_table" "test-table" {
  name           = "test-dynamodb"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }
}