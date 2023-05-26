variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = string
  default = "eu-central-1a"
}

variable "node_env" {
  description = "The node environment"
  type        = string
  default     = "production"
}

variable "db_path" {
  description = "The path to the database"
  type        = string
  default     = "/data/db.sqlite"
}

variable "github_sha" {
  description = "The commit SHA of the GitHub commit being deployed"
  type        = string
  default     = ""
}

variable "sentinel_http_rpc_node" {
  description = "The HTTP RPC node for Sentinel"
  type        = string
  default     = "https://eth-goerli.g.alchemy.com/v2/I2yUg8ELdX4xWoJawACRJWfY2VIQus1B"
}

variable "sentinel_fastsync" {
  description = "Flag to enable/disable fastsync"
  type        = bool
  default     = true
}

variable "sentinel_observer" {
  description = "Flag to enable/disable observer mode"
  type        = bool
  default     = true
}
