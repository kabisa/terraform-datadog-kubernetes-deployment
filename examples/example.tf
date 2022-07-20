# tflint-ignore: terraform_module_version
module "my_deployment" {
  source               = "kabisa/kubernetes-deployment/datadog"
  env                  = "prd"
  notification_channel = "mail@example.com"
  filter_str           = "cluster_name:my-cluster,kube_deployment:my-deployment"
}
