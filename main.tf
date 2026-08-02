resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

resource "local_file" "manifest" {
  filename        = "${path.module}/out/manifest.txt"
  content         = "repo: ${random_pet.name.id}\n"
  file_permission = "0644"
}