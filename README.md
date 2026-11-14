# devops-iac-aws-lab

Build, configure, observe and load-balance an infrastructure as code, on AWS (parts 02 and 03 run locally with Docker Compose).

| Part | What it does | Tools |
|---|---|---|
| [00-bootstrap](./00-bootstrap) | create the S3 bucket that stores the Terraform state of every part | Terraform |
| [01-provision-configure](./01-provision-configure) | provision an EC2 instance, then deploy an Angular app served by nginx | Terraform, Ansible |
| [02-observability-elk](./02-observability-elk) | index nginx access logs and build a Kibana dashboard | Elasticsearch, Kibana (Docker Compose) |
| [03-load-balancing](./03-load-balancing) | spread traffic across two web servers, with health checks | HAProxy (Docker Compose) |

Decisions and their reasons are recorded in [docs/decisions.md](./docs/decisions.md).

## Getting started

1. Run [00-bootstrap](./00-bootstrap) once per AWS account: it creates the state bucket.
2. Follow the README of each part, in order. Each part has its own Terraform state.
3. End every AWS session with `terraform destroy` in the part's folder (`docker compose down -v` for 02 and 03).

## Status

| Part | Status |
|---|---|
| 00-bootstrap | done |
| 01-provision-configure | done |
| 02-observability-elk | done |
| 03-load-balancing | done |

## Credits

Based on the OpenClassrooms starter kit [DevOps-4091](https://github.com/OpenClassrooms-Student-Center/DevOps-4091) (first commit of this repository), from the "DevOps Expert" path.
