# Exercice 1 - Option AWS

## Préparer son environnement

Pour démarrer votre machine virtuelle, lancer les commandes suivantes:

```bash
terraform init
terraform apply

# Une fois le déploiement terminé, faire
terraform show
```

Dans la sortie de la commande `terraform show`, identifiez la valeur de l'attribut `public_dns` de la ressource `aws_instance.my_server`.

Ceci est le nom d'hôte publique de votre machine virtuelle.

Vous devriez pouvoir faire:

```bash
ssh -v ubuntu@<public_dns>
```

> **Note** Si la connexion échoue, réessayez avec la commande `ssh -i ~/.ssh/aws_openclassrooms_edo_p5.pem -o IdentitiesOnly=yes ubuntu@<public_dns>`. Celle-ci force le client SSH à utiliser la clé privée générée par Terraform pour accéder à la machine virtuelle.

La connexion SSH fonctionne ? Vous êtes prêt pour réaliser la seconde partie de l'exercice (Ansible)

## À la fin de l'exercice

Pensez à faire un `terraform destroy` afin de supprimer toutes les ressources créées sur la plateforme AWS.
