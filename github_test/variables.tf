variable "token" {
  type        = string
  description = "for the github connection"
  default     = "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"
}


variable "paths_result" {
  type        = list(any)
  description = "file paths to github"
  default     = ["app.py", "Dockerfile", "index.html", "requirements.txt"]
}

variable "basepath_web" {
  type        = string
  description = "base path to files directory"
  default     = "C:/Users/USER/Envs/milestone_projects/K8s-Terra-Phonebook/solution/containers/web"
}

variable "paths_web" {
  type        = list(any)
  description = "file paths to github"
  default     = ["app.py", "Dockerfile", "index.html", "requirements.txt", "delete.html", "add-update.html"]
}

variable "basepath_result" {
  type        = string
  description = "base path to files directory"
  default     = "C:/Users/USER/Envs/milestone_projects/K8s-Terra-Phonebook/solution/containers/result"
}