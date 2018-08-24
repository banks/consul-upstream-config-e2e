service {
  name = "deprecated-proxy"
  port = 3333
  kind = "connect-proxy"
  proxy_destination = "web"
}