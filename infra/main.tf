module "cluster" {
    source = "./modules/cluster"
    nodes = var.nodes
}