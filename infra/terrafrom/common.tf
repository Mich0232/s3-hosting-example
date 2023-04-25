resource "random_pet" "this" {}

locals {
  prefix       = "hosting-test-${random_pet.this.id}"
  s3_origin_id = "s3-bucket-with-react-app"
  tags = {
    ProjectName = "ReactAppS3HostingTest"
  }
}
