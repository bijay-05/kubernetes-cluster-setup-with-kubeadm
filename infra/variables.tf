variable "nodes" {
    type = map(object({
        name = string
        node_size = string
        admin_username = string
        public = bool
        custom_data_path = string
    }))
}