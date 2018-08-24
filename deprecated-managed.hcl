service {
  name = "deprecated-managed"
  port = 1111
  connect {
    proxy {
      config {
        upstreams = [
          {
            destination_name = "db"
            local_bind_port = 1234
            connect_timeout_ms = 1000
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
}