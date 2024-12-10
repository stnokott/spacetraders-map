variable "triggers" {
  type = map(object({
    name         = string
    description  = string
    event_type   = string
    filter_type  = string
    filter_value = string
    deploy_to    = string
  }))
  description = "Map of Cloud Build trigger names and their definitions. Each key will produce a separate trigger."

  validation {
    condition = (
      alltrue([for trigger in var.triggers :
        # validate possible values for event_type
        contains(["push", "pull_request"], trigger.event_type) &&
        # validate possible values for filter_type
        contains(["tag", "branch"], trigger.filter_type) &&
        # validate filter_value not empty
        length(trigger.filter_value) > 0 &&
        # validate possible values for deploy_to
        contains(["dev", "prod"], trigger.deploy_to) &&
        # ensure we are not filtering by tag on PR (not possible)
        !(trigger.event_type == "pull_request" && trigger.filter_type == "tag")
      ])
    )
    error_message = "Trigger definitions are invalid, check variable validation."
  }
}
