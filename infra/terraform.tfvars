nodes = {
    "node_1" = {
        name = "master",
        node_size = "Standard_B1ms",
        admin_username = "masteruser"
        public = true
        custom_data_path = "./setup.sh"
      },
      # "node_2" = {
      #   name = "node-0",
      #   node_size = "Standard_B1ms",
      #   admin_username = "workeruser"
      #   public = false
      # },
      # "node_3" = {
      #   name = "node-1",
      #   node_size = "Standard_B1ms",
      #   admin_username = "workeruser"
      #   public = false
      # }
}
