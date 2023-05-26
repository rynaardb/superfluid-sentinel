resource "aws_ecr_repository" "repository" {
  name                 = "superfluid-test-ecr"
  image_tag_mutability = "MUTABLE"
}
