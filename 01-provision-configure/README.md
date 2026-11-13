# Exercise 1 — Provision and configure

Terraform creates the server, then Ansible installs what runs on it: nginx serving the Angular app.

| Folder | Role | Status |
|---|---|---|
| [terraform](./terraform) | create the EC2 instance, its firewall and SSH access | done |
| [ansible](./ansible) | install nginx, deploy the Angular app and its nginx configuration | done |
