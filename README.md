# devops-iac-aws-lab

Build, configure, observe and load-balance an infrastructure on AWS, entirely as code.

| Part | What it does | Tools |
|---|---|---|
| [01-provision-configure](./01-provision-configure) | provision an EC2 instance, then deploy an Angular app served by nginx | Terraform, Ansible |
| [02-observability-elk](./02-observability-elk) | index nginx access logs and build a Kibana dashboard | OpenSearch, Kibana |
| [03-load-balancing](./03-load-balancing) | spread traffic across two web servers, with health checks | HAProxy |

Decisions and their reasons are recorded in [docs/decisions.md](./docs/decisions.md).

## Status

Work in progress: the folders still hold the starter kit, rewritten part by part.

## Credits

Based on the OpenClassrooms starter kit [DevOps-4091](https://github.com/OpenClassrooms-Student-Center/DevOps-4091) (first commit of this repository), from the "DevOps Expert" path.
