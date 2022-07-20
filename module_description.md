This module has overlap with https://github.com/kabisa/terraform-datadog-kubernetes
If you're using that one already you might not need this one.

You may want to use this module when you want different notification channels per deployment. 
This might be relevant for example when you have different teams for development and for infra.

This module is best used together with: https://github.com/kabisa/terraform-datadog-docker-container
That one does resource (cpu/network/memory/disk) alerts. This one doesn't