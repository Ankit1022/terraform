# providers variables description

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "access_key id"
  default     = "AKIA3OOMQ53VDQGGZCUT"
}
variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "secret_key id"
  default     = "ZDULmiR4ha3FghWugP3WrzXfs+rwVDmfI5cLZ6Tz"
}

variable "policy_arn_list" {
  type = list(any)
  default = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  "arn:aws:iam::aws:policy/AmazonSSMFullAccess"]
}
