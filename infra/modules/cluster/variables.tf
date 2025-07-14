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
        node_size = "Standard_B2s",
        admin_username = "masteruser"
        public = true
      },
      "node_2" = {
        name = "node-0",
        node_size = "Standard_B1ms",
        admin_username = "workeruser"
        public = false
      },
      "node_3" = {
        name = "node-1",
        node_size = "Standard_B1ms",
        admin_username = "workeruser",
        public = false
      }
    }

}
