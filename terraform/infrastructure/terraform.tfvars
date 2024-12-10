triggers = {
  tag_dev = {
    name         = "tag-dev"
    description  = "Deploy to [dev] when tag 'dev' is pushed"
    event_type   = "push"
    filter_type  = "tag"
    filter_value = "^dev$"
    steps = {
      build = {
        image_tag = "dev"
      }
      deploy = {
        env = "dev"
      }
    }
  }
  pull_request_main = {
    name         = "pull-request-main"
    description  = "Deploy to [dev] when PR to 'main' is raised"
    event_type   = "pull_request"
    filter_type  = "branch"
    filter_value = "^main$"
    steps = {
      test = {}
      build = {
        image_tag = "$BRANCH_NAME"
      }
    }
  }
  push_main = {
    name         = "push-main"
    description  = "Deploy to [prod] when pushed/merged to 'main'"
    event_type   = "push"
    filter_type  = "branch"
    filter_value = "^main$"
    steps = {
      build = {
        image_tag = "prod"
      }
      deploy = {
        env = "prod"
      }
    }
  }
}
