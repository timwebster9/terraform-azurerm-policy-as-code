resource azurerm_management_group_policy_assignment def {
  count                = local.assignment_scope.mg
  name                 = local.assignment_name
  display_name         = local.display_name
  description          = local.description
  management_group_id  = var.assignment_scope
  not_scopes           = var.assignment_not_scopes
  enforce              = var.assignment_enforcement_mode
  policy_definition_id = var.definition.id
  parameters           = local.parameters
  location             = var.assignment_location

  dynamic "non_compliance_message" {
    for_each = local.non_compliance_message
    content {
      content = non_compliance_message.value
    }
  }

  dynamic "identity" {
    for_each = local.identity_type
    content {
      type = identity.value
    }
  }
}

resource azurerm_subscription_policy_assignment def {
  count                = local.assignment_scope.sub
  name                 = local.assignment_name
  display_name         = local.display_name
  description          = local.description
  subscription_id      = var.assignment_scope
  not_scopes           = var.assignment_not_scopes
  enforce              = var.assignment_enforcement_mode
  policy_definition_id = var.definition.id
  parameters           = local.parameters
  location             = var.assignment_location

  dynamic "non_compliance_message" {
    for_each = local.non_compliance_message
    content {
      content = non_compliance_message.value
    }
  }

  dynamic "identity" {
    for_each = local.identity_type
    content {
      type = identity.value
    }
  }
}


resource azurerm_resource_group_policy_assignment def {
  count                = local.assignment_scope.rg
  name                 = local.assignment_name
  display_name         = local.display_name
  description          = local.description
  resource_group_id    = var.assignment_scope
  not_scopes           = var.assignment_not_scopes
  enforce              = var.assignment_enforcement_mode
  policy_definition_id = var.definition.id
  parameters           = local.parameters
  location             = var.assignment_location

  dynamic "non_compliance_message" {
    for_each = local.non_compliance_message
    content {
      content = non_compliance_message.value
    }
  }

  dynamic "identity" {
    for_each = local.identity_type
    content {
      type = identity.value
    }
  }
}

resource azurerm_resource_policy_assignment def {
  count                = local.assignment_scope.resource
  name                 = local.assignment_name
  display_name         = local.display_name
  description          = local.description
  resource_id          = var.assignment_scope
  not_scopes           = var.assignment_not_scopes
  enforce              = var.assignment_enforcement_mode
  policy_definition_id = var.definition.id
  parameters           = local.parameters
  location             = var.assignment_location

  dynamic "non_compliance_message" {
    for_each = local.non_compliance_message
    content {
      content = non_compliance_message.value
    }
  }

  dynamic "identity" {
    for_each = local.identity_type
    content {
      type = identity.value
    }
  }
}

## role assignments ##
resource azurerm_role_assignment rem_role {
  for_each                         = toset(local.role_definition_ids)
  scope                            = local.role_assignment_scope
  role_definition_id               = each.value
  principal_id                     = local.assignment.identity[0].principal_id
  skip_service_principal_aad_check = true
}

## remediation tasks ##
resource azurerm_management_group_policy_remediation rem {
  count                   = local.create_remediation + local.remediate.mg > 1 ? 1 : 0
  name                    = lower("${var.definition.name}-${formatdate("DD-MM-YYYY-hh:mm:ss", timestamp())}")
  management_group_id     = local.remediation_scope
  policy_assignment_id    = local.assignment.id
  location_filters        = var.location_filters
}

resource azurerm_subscription_policy_remediation rem {
  count                   = local.create_remediation + local.remediate.sub > 1 ? 1 : 0
  name                    = lower("${var.definition.name}-${formatdate("DD-MM-YYYY-hh:mm:ss", timestamp())}")
  subscription_id         = local.remediation_scope
  policy_assignment_id    = local.assignment.id
  resource_discovery_mode = var.resource_discovery_mode
  location_filters        = var.location_filters
}

resource azurerm_resource_group_policy_remediation rem {
  count                   = local.create_remediation + local.remediate.rg > 1 ? 1 : 0
  name                    = lower("${var.definition.name}-${formatdate("DD-MM-YYYY-hh:mm:ss", timestamp())}")
  resource_group_id       = local.remediation_scope
  policy_assignment_id    = local.assignment.id
  resource_discovery_mode = var.resource_discovery_mode
  location_filters        = var.location_filters
}

resource azurerm_resource_policy_remediation rem {
  count                   = local.create_remediation + local.remediate.resource > 1 ? 1 : 0
  name                    = lower("${var.definition.name}-${formatdate("DD-MM-YYYY-hh:mm:ss", timestamp())}")
  resource_id             = local.remediation_scope
  policy_assignment_id    = local.assignment.id
  resource_discovery_mode = var.resource_discovery_mode
  location_filters        = var.location_filters
}
