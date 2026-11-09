# Exercice 1 - Option "Docker"

## Préparer son environnement

Pour démarrer votre machine virtuelle, lancer les commandes suivantes:

```bash
terraform init
terraform apply
```

Vous pouvez ensuite suivre l'avancée du déploiement via la commande suivante:

```bash
docker logs -f openclassrooms-p5-edo
```

Votre machine virtuelle sera disponible lorsque vous verrez le message suivant s'afficher:

```shell
Ubuntu 24.04 LTS openclassrooms ttyS0
```

Vous devriez pouvoir ensuite vous connecter en SSH via la commande suivante:

```bash
ssh -o PreferredAuthentications=password openclassrooms@127.0.0.1 -p 2222
```

Le mot de passe par défaut est `openclassrooms`. Le compte `openclassrooms` fait partie des `sudoers`.

La connexion SSH fonctionne ? Vous êtes prêt pour la suite de l'exercice (Ansible).

> **Note** N'hésitez pas à copier votre clé SSH sur la machine afin de simplifier votre connexion à celle-ci (notamment pour simplifier les opérations avec Ansible).

## À la fin de l'exercice

Pensez à faire un `terraform destroy` afin de supprimer toutes les ressources créées.

## Ressources

### Configuration par défaut

Le port `80 (TCP)` de la machine est exposé sur votre machine hôte. Ainsi, depuis votre machine hôte, si vous ouvrez l'URL http://localhost vous devriez vous connecter sur le port 80 de la machine virtuelle (par défaut aucun serveur HTTP n'est installé, vous aurez donc une erreur avant de finaliser l'exercice).

Une interface VNC est également disponible à l'adresse http://localhost:8006 (attention cependant, cette interface utilise un clavier QWERTY).

### Liens

- https://powersj.io/posts/ubuntu-qemu-cli/
