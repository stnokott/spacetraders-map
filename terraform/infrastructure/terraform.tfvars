triggers = {
  tag_dev = {
    name         = "tag-dev"
    description  = "Deploy [dev] when tag 'dev' is pushed"
    event_type   = "push"
    filter_type  = "tag"
    filter_value = "^dev$"
    deploy_to    = "dev"
  }
  pull_request_main = {
    name         = "pull-request-main"
    description  = "Deploy [dev] when PR to 'main' is raised"
    event_type   = "pull_request"
    filter_type  = "branch"
    filter_value = "^main$"
    deploy_to    = "dev"
  }
  push_main = {
    name         = "push-main"
    description  = "Deploy [prod] when pushed/merged to 'main'"
    event_type   = "push"
    filter_type  = "branch"
    filter_value = "^main$"
    deploy_to    = "prod"
  }
}
