# A stack yatta can run end to end without any cloud account: nothing here needs
# credentials, so a run proves the pipeline rather than an integration.

terraform {
  required_version = ">= 1.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "environment" {
  description = "Environment this stack is deployed for."
  type        = string
}

variable "region" {
  description = "Region label. It exists to prove a stack's variables reach the tool."
  type        = string
}

resource "random_pet" "release" {
  prefix = var.environment
}

# Deliberately outside the working copy: yatta re-clones it when a clone was left
# half-finished, and anything the run created in there would come back as drift.
resource "local_file" "release" {
  filename = "/tmp/yatta-${var.environment}.txt"
  content  = "${random_pet.release.id} (${var.region})\n"
}

output "release" {
  value = random_pet.release.id
}
