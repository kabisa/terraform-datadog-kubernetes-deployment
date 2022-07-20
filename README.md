
![Datadog](https://imgix.datadoghq.com/img/about/presskit/logo-v/dd_vertical_purple.png)

[//]: # (This file is generated. Do not edit, module description can be added by editing / creating module_description.md)

# Terraform module for Datadog Kubernetes Deployment

This module has overlap with https://github.com/kabisa/terraform-datadog-kubernetes
If you're using that one already you might not need this one.

You may want to use this module when you want different notification channels per deployment. 
This might be relevant for example when you have different teams for development and for infra.

This module is best used together with: https://github.com/kabisa/terraform-datadog-docker-container
That one does resource (cpu/network/memory/disk) alerts. This one doesn't

This module is part of a larger suite of modules that provide alerts in Datadog.
Other modules can be found on the [Terraform Registry](https://registry.terraform.io/search/modules?namespace=kabisa&provider=datadog)

We have two base modules we use to standardise development of our Monitor Modules:
- [generic monitor](https://github.com/kabisa/terraform-datadog-generic-monitor) Used in 90% of our alerts
- [service check monitor](https://github.com/kabisa/terraform-datadog-service-check-monitor)

Modules are generated with this tool: https://github.com/kabisa/datadog-terraform-generator

# Example Usage

```terraform
# tflint-ignore: terraform_module_version
module "aws_eu_west_1" {
  source = "kabisa/aws-services/datadog"

  for_each = toset([
    "cloudformation",
    "cloudtrail",
    "cloudwatch",
    "directconnect",
    "ec2",
    "ecr",
    "ecs",
    "eks",
    "elasticache",
    "elasticsearch",
    "elb",
    "kms",
    "lambda",
    "rds",
    "route53",
    "s3",
    "ses",
    "sns",
    "sqs",
    "vpc",
  ])
  env                  = "prd"
  notification_channel = "mail@example.com"

  include_tags = [
    "region:eu-west-1",
    "service:${each.key}"
  ]
  by_tags = [
    "service"
  ]
  name_suffix = each.key
}

```

Monitors:
* [Terraform module for Datadog Kubernetes Deployment](#terraform-module-for-datadog-kubernetes-deployment)
  * [Deploy Desired Vs Status](#deploy-desired-vs-status)
  * [Deployment Multiple Restarts](#deployment-multiple-restarts)
  * [Module Variables](#module-variables)

# Getting started developing
[pre-commit](http://pre-commit.com/) was used to do Terraform linting and validating.

Steps:
   - Install [pre-commit](http://pre-commit.com/). E.g. `brew install pre-commit`.
   - Run `pre-commit install` in this repo. (Every time you cloud a repo with pre-commit enabled you will need to run the pre-commit install command)
   - That’s it! Now every time you commit a code change (`.tf` file), the hooks in the `hooks:` config `.pre-commit-config.yaml` will execute.

## Deploy Desired Vs Status

The amount of expected pods to run minus the actual number

Query:
```terraform
avg(last_15m):max:kubernetes_state.deployment.replicas_desired{tag:xxx} by {cluster_name,host} - max:kubernetes_state.deployment.replicas{tag:xxx} by {cluster_name,host} > 2
```

| variable                                   | default                                  | required | description                      |
|--------------------------------------------|------------------------------------------|----------|----------------------------------|
| deploy_desired_vs_status_enabled           | True                                     | No       |                                  |
| deploy_desired_vs_status_warning           | 1                                        | No       |                                  |
| deploy_desired_vs_status_critical          | 2                                        | No       |                                  |
| deploy_desired_vs_status_evaluation_period | last_15m                                 | No       |                                  |
| deploy_desired_vs_status_note              | ""                                       | No       |                                  |
| deploy_desired_vs_status_docs              | The amount of expected pods to run minus the actual number | No       |                                  |
| deploy_desired_vs_status_filter_override   | ""                                       | No       |                                  |
| deploy_desired_vs_status_alerting_enabled  | True                                     | No       |                                  |
| deploy_desired_vs_status_no_data_timeframe | None                                     | No       |                                  |
| deploy_desired_vs_status_notify_no_data    | False                                    | No       |                                  |
| deploy_desired_vs_status_ok_threshold      | None                                     | No       |                                  |
| deploy_desired_vs_status_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## Deployment Multiple Restarts

If a container restarts once, it can be considered 'normal behaviour' for K8s. A Deployment restarting multiple times though is a problem

Query:
```terraform
max(last_15m):clamp_min(max:kubernetes.containers.restarts{tag:xxx} by {kube_deployment} - hour_before(max:kubernetes.containers.restarts{tag:xxx} by {kube_deployment}), 0) > 5.0
```

| variable                                                   | default                                  | required | description                      |
|------------------------------------------------------------|------------------------------------------|----------|----------------------------------|
| deployment_multiple_restarts_enabled                       | True                                     | No       |                                  |
| deployment_multiple_restarts_warning                       | None                                     | No       |                                  |
| deployment_multiple_restarts_critical                      | 5.0                                      | No       |                                  |
| deployment_multiple_restarts_evaluation_period             | last_15m                                 | No       |                                  |
| deployment_multiple_restarts_note                          | ""                                       | No       |                                  |
| deployment_multiple_restarts_docs                          | If a container restarts once, it can be considered 'normal behaviour' for K8s. A Deployment restarting multiple times though is a problem | No       |                                  |
| deployment_multiple_restarts_filter_override               | ""                                       | No       |                                  |
| deployment_multiple_restarts_alerting_enabled              | True                                     | No       |                                  |
| deployment_multiple_restarts_no_data_timeframe             | None                                     | No       |                                  |
| deployment_multiple_restarts_notify_no_data                | False                                    | No       |                                  |
| deployment_multiple_restarts_ok_threshold                  | None                                     | No       |                                  |
| deployment_multiple_restarts_name_prefix                   | ""                                       | No       |                                  |
| deployment_multiple_restarts_name_suffix                   | ""                                       | No       |                                  |
| deployment_multiple_restarts_priority                      | 3                                        | No       | Number from 1 (high) to 5 (low). |
| deployment_multiple_restarts_notification_channel_override | ""                                       | No       |                                  |


## Module Variables

| variable                 | default  | required | description                                                                                          |
|--------------------------|----------|----------|------------------------------------------------------------------------------------------------------|
| filter_str               |          | Yes      |                                                                                                      |
| env                      |          | Yes      | This refers to the environment or which stage of deployment this monitor is checking. Good values are prd, acc, tst, dev... |
| service                  | ""       | No       | Service name of what you're monitoring. This also sets the service:<service> tag on the monitor      |
| service_display_name     | None     | No       | Readable version of service name of what you're monitoring.                                          |
| notification_channel     | ""       | No       | Channel to which datadog sends alerts, will be overridden by alerting_enabled if that's set to false |
| additional_tags          | []       | No       | Additional tags to set on the monitor. Good tagging can be hard but very useful to make cross sections of the environment. Datadog has a few default tags. https://docs.datadoghq.com/getting_started/tagging/ is a good place to start reading about tags |
| locked                   | True     | No       | Makes sure only the creator or admin can modify the monitor                                          |
| name_prefix              | ""       | No       | Can be used to prefix to the Monitor name                                                            |
| name_suffix              | ""       | No       | Can be used to suffix to the Monitor name                                                            |
| filter_str_concatenation | ,        | No       | If you use an IN expression you need to switch from , to AND                                         |
| priority_offset          | 0        | No       | For non production workloads we can +1 on the priorities                                             |


