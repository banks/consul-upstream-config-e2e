service {
  name = "new-managed"
  port = 2222
  connect {
    proxy {
      upstreams = [
        {
          destination_name = "db"
          local_bind_port = 1234
          config = {
            connect_timeout_ms = 1000
          }
        },
        {
          destination_type = "prepared_query"
          destination_name = "geo-cache"
          local_bind_port = 1235
        },
      ]
    }
  }
}