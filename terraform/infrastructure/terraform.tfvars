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
      lint = {}
      test = {}
      build = {
        image_tag = "$BRANCH_NAME"
      }
    }
  }

  preprod_deploy = {
    name         = "preprod-deploy"
    description  = "Deploy to [preprod] when merged to 'main'. Used as deploy condition for [prod]."
    event_type   = "push"
    filter_type  = "branch"
    filter_value = "^main$"
    steps = {
      build = {
        image_tag = "preprod"
      }
      deploy = {
        env = "preprod"
      }
    }
  }

  tag_semver = {
    name         = "tag-semver"
    description  = "Deploy to [prod] when SemVer tag pushed"
    event_type   = "push"
    filter_type  = "tag"
    filter_value = "^v\\d+\\.\\d+\\.\\d+$"
    steps = {
      build = {
        image_tag = "$TAG_NAME"
      }
      deploy = {
        env = "prod"
      }
    }
  }
}
