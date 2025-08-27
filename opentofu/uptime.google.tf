# resource "google_monitoring_uptime_check_config" "zue_dev_http" {
#   display_name = "https://zue.dev"
#   timeout      = "10s"
#   period       = "900s"

#   http_check {
#     path         = "/"
#     port         = 443
#     use_ssl      = true
#     validate_ssl = true
#   }

#   monitored_resource {
#     type = "uptime_url"
#     labels = {
#       host = "zue.dev"
#     }
#   }

#   content_matchers {
#     matcher = "MATCHES_REGEX"
#     content = ".*"
#   }
# }
