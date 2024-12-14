triggers = {
  deploy_dev = {
    name         = "deploy-dev"
    description  = "Deploy to [dev] when tagged 'dev'"
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

  build_branch = {
    name         = "build-branch"
    description  = "Build image on PR to 'main'"
    event_type   = "pull_request"
    filter_type  = "branch"
    filter_value = "^main$"
    steps = {
      build = {
        image_tag = "$BRANCH_NAME"
      }
    }
  }

  test_branch = {
    name         = "test-branch"
    description  = "Run tests on PR to 'main'"
    event_type   = "pull_request"
    filter_type  = "branch"
    filter_value = "^main$"
    steps = {
      test = {}
    }
  }

  lint_branch = {
    name         = "lint-branch"
    description  = "Lint code on PR to 'main'"
    event_type   = "pull_request"
    filter_type  = "branch"
    filter_value = "^main$"
    steps = {
      lint = {}
    }
  }

  preprod_deploy = {
    name             = "deploy-preprod"
    description      = "Deploy to [preprod] when merged to 'main'. Used as deploy condition for [prod]."
    event_type       = "push"
    filter_type      = "branch"
    filter_value     = "^main$"
    require_approval = true // require approval so we don't redundantly trigger this step when we don't intend to release to prod
    steps = {
      build = {
        image_tag = "preprod"
      }
      deploy = {
        env = "preprod"
      }
    }
  }

  prod_deploy = {
    name         = "deploy-prod"
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
