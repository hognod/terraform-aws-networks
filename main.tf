locals {
  vpc_list = distinct([ for v in csvdecode(file("./networks.csv")) : v.vpc_name ])
  vpc_subnet = { for k, v in local.vpc_list : v => { for k2, v2 in csvdecode(file("./networks.csv")) : v2.subnet_cidr => v2 if (v == v2.vpc_name && v2.enable == "true") } }
}

module "networks" {
  for_each = local.vpc_subnet
  source = "./networks"

  networks = each.value
}