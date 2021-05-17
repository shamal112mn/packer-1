
variable "google_project_id" {
  default = "angular-unison-267720"
}


variable "namespaces" {
  type    = "list"
  default = [     
    "tools",
    "default",
    "test",
    "dev-students",
    "qa-students"
  ]
}
