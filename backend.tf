terraform {
  backend "s3" {
    bucket = "terraform-bunzlau-state"
    key    = "LockId"
    region = "eu-west-1"

    use_lockfile   = true
    encrypt        = true
  }
}