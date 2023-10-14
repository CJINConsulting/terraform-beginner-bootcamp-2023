## Terrahome AWS

The following directory

```tf
module "home_japan" {
  source              = "./modules/terrahome_aws"
  user_uuid           = var.teacherseat_user_uuid
  public_path = var.japan_public_path
  content_version     = var.content_version
}
```

It's important to note that the public directory expects the following:

- index.html
- error.html
- assets

All top level files in assets will be copied, but not any sub-directories.