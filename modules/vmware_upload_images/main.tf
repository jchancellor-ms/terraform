locals {
  images = { for image in var.images : image.name => image }
}

data "vsphere_content_library" "library" {
  name = var.content_library_name
}

resource "vsphere_content_library_item" "imageUpload" {
  for_each = local.images

  name        = each.value.name
  description = each.value.description
  library_id  = vsphere_content_library.library.id
  file_url    = each.value.file_url
}