variable "nodes" {
    type = map(object({
        name = string
        node_size = string
        admin_username = string
        public = bool
    }))
    default = {
      "node_1" = {
        name = "master",
        node_size = "Standard_D4s_v3",
        admin_username = "demon-master"
        public = true
      },
      "node_2" = {
        name = "worker",
        node_size = "Standard_B2s",
        admin_username = "demon-worker"
        public = false
      }
    }

}
