# devops-iac-aws-lab

Build, configure, observe and load-balance an infrastructure on AWS, entirely as code.

| Part | What it does | Tools |
|---|---|---|
| [00-bootstrap](./00-bootstrap) | create the S3 bucket that stores the Terraform state of every part | Terraform |
| [01-provision-configure](./01-provision-configure) | provision an EC2 instance, then deploy an Angular app served by nginx | Terraform, Ansible |
| [02-observability-elk](./02-observability-elk) | index nginx access logs and build a Kibana dashboard | OpenSearch, Kibana |
| [03-load-balancing](./03-load-balancing) | spread traffic across two web servers, with health checks | HAProxy |

Decisions and their reasons are recorded in [docs/decisions.md](./docs/decisions.md).

## Getting started

1. Run [00-bootstrap](./00-bootstrap) once per AWS account: it creates the state bucket.
2. Follow the README of each part, in order. Each part has its own Terraform state.
3. End every session with `terraform destroy` in the part's folder.

## Status

| Part | Status |
|---|---|
| 00-bootstrap | done |
| 01-provision-configure | done |
| 02-observability-elk, 03-load-balancing | starter kit, not started |

## Credits

Based on the OpenClassrooms starter kit [DevOps-4091](https://github.com/OpenClassrooms-Student-Center/DevOps-4091) (first commit of this repository), from the "DevOps Expert" path.
