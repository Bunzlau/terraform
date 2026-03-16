terraform {
  backend "s3" {
    bucket = "terraform-bunzlau-state-v2"
    key    = "LockId"
    region = "eu-north-1"

    use_lockfile   = true
    encrypt        = true
  }
}