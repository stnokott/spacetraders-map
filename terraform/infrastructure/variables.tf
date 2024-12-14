variable "triggers" {
  type = map(object({
    name         = string
    description  = string
    event_type   = string
    filter_type  = string
    filter_value = string
    steps = object({
      lint = optional(object({}))
      test = optional(object({}))
      build = optional(object({
        image_tag = string
      }))
      deploy = optional(object({
        env = string
      }))
    })
  }))
  description = "Map of Cloud Build trigger names and their definitions. Each key will produce a separate trigger."

  validation {
    condition = alltrue([for trigger in var.triggers :
      contains(["push", "pull_request"], trigger.event_type)
    ])
    error_message = "Invalid value for event_type, needs to be one of ('push', 'pull_request')."
  }

  validation {
    condition = alltrue([for trigger in var.triggers :
      contains(["tag", "branch"], trigger.filter_type)
    ])
    error_message = "Invalid value for filter_type, needs to be one of ('tag', 'branch)."
  }

  validation {
    condition = alltrue([for trigger in var.triggers :
      length(trigger.filter_value) > 0
    ])
    error_message = "Invalid value for filter_value, needs to be non-empty."
  }

  validation {
    condition = alltrue([for trigger in var.triggers :
      !(trigger.event_type == "pull_request" && trigger.filter_type == "tag")
    ])
    error_message = "Cannot combine event_type = 'pull_request' and filter_type = 'tag'."
  }

  validation {
    condition = alltrue([for trigger in var.triggers :
      trigger.steps.deploy == null || trigger.steps.build != null
    ])
    error_message = "When specifying steps.deploy, steps.build also needs to be specified."
  }

  validation {
    condition = alltrue([for trigger in var.triggers :
      trigger.steps.deploy == null ? true : contains(["dev", "preprod", "prod"], trigger.steps.deploy.env)
    ])
    error_message = "Invalid value for steps.deploy.env, needs to be one of ('dev', 'preprod', 'prod')."
  }
}
