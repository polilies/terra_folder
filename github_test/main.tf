# Please change the key_name and your config file 
terraform {
  required_providers {

    github = {
      source  = "integrations/github"
      version = "5.18.3"
    }
  }
}

provider "github" {
  token = var.token # or `GITHUB_TOKEN`
}





resource "github_repository" "k8s_phonebook_web" {
  name        = "k8s_phone"
  description = "docker-compose, docker build, terraform github repo creation, aws_ec2 "
  auto_init   = true
  visibility  = "public"
  #branch      = "main"
  /*   template {
    owner                = "github"
    repository           = "polilies  "
    include_all_branches = true
  } */
}
/* resource "github_repository" "k8s_phonebook_result" {
  name        = "k8s_phone"
  description = "docker-compose, docker build, terraform github repo creation, aws_ec2 "
  auto_init   = true
  visibility  = "public"
  #branch      = "main"
  /*   template {
    owner                = "github"
    repository           = "polilies  "
    include_all_branches = true
  } */


resource "github_repository_file" "web" {
  for_each            = toset(var.paths_web)
  content             = file("${var.basepath_web}/${each.value}")
  file                = "web/${each.value}"
  repository          = github_repository.k8s_phonebook_web.name
  overwrite_on_create = true
  branch              = "main"
}

resource "github_repository_file" "result" {
  for_each            = toset(var.paths_result)
  content             = file("${var.basepath_result}/${each.value}")
  file                = "result/${each.value}"
  repository          = github_repository.k8s_phonebook_web.name
  overwrite_on_create = true
  branch              = "main"
}


