locals {
  users_set                = toset(var.users)
  cluster_environments_set = toset(var.cluster_environments)
}

data "opsgenie_user" "users" {
  for_each = local.users_set
  username = each.key
}

resource "opsgenie_team" "teams" {
  for_each = local.cluster_environments_set

  name                     = "${var.company_key}-${each.value}-team"
  description              = "This is for company ${var.company_key} in the ${each.value} environment"
  delete_default_resources = true

  dynamic "member" {
    for_each = data.opsgenie_user.users

    content {
      id   = member.value.id
      role = "user"
    }
  }
}

resource "opsgenie_schedule" "schedules" {
  for_each = local.cluster_environments_set

  name          = "${var.company_key}-${each.value}-schedule"
  description   = "This is for company ${var.company_key} in the ${each.value} environment"
  timezone      = "Africa/Monrovia"
  owner_team_id = opsgenie_team.teams[each.key].id
  enabled       = true
}

resource "opsgenie_schedule_rotation" "rotations" {
  for_each = local.cluster_environments_set

  schedule_id = opsgenie_schedule.schedules[each.key].id
  name        = "${var.company_key}-${each.value}-rotation"

  dynamic "participant" {
    for_each = data.opsgenie_user.users

    content {
      type = "user"
      id   = participant.value.id
    }
  }

  start_date = "2023-03-14T09:00:00Z" # Set the start date and time for the rotation
  type       = "weekly"
  length     = 1
}

resource "opsgenie_api_integration" "prometheus" {
  for_each = local.cluster_environments_set
  name     = "${var.company_key}-${each.value}-prometheus-api-int"
  type     = "API"

  responders {
    type = "team"
    id   = opsgenie_team.teams[each.key].id
  }

  enabled                        = true
  allow_write_access             = true
  ignore_responders_from_payload = true
  suppress_notifications         = false
  owner_team_id                  = opsgenie_team.teams[each.key].id
}
