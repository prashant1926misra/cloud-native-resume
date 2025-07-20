/*
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item
*/

resource "aws_dynamodb_table" "visitor_count_table" {
  name         = "visitor_count_table"
  billing_mode = "PAY_PER_REQUEST"  # Controls how you are charged for read and write throughput. Default - Provisioned 
  hash_key     = "id"               # Parition key eg user1 user2... must be unique 

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "visitor_count_table"
    Environment = "DEV"
  }

}

resource "aws_dynamodb_table_item" "initial_item" {
  table_name = aws_dynamodb_table.visitor_count_table.name
  hash_key   = aws_dynamodb_table.visitor_count_table.hash_key

  item = <<ITEM
{
  "id": {"S": "visits"},
  "count": {"N": "0"}
}
ITEM
}
