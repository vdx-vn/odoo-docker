# Odoo community Docker images

- Odoo version: 18
- Postgres version: 16

## Prerequisite and Installation

Install docker and docker compose

- [Docker](https://docs.docker.com/engine/install/)

- [Docker compose plugin](https://docs.docker.com/compose/install/linux/)

- [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/)

## How to build and publish customized Odoo image on Docker hub

1. Run build image command

    ```shell
    cd $ODOO_DOCKER_PATH/dockerfile
    docker build -f Dockerfile --pull -t xmars/odoo:18 .
    ```

2. _(Optionally)_ Push newly image to Docker hub

    ```shell
    docker login
    docker push xmars/odoo:18
    ```

3. _(Optionally)_ if you want to install some libs, edit file [requirements.txt](requirements.txt) and [entrypoint.sh](entrypoint.sh) and rebuild the image

## Tip and Tricks

- Clean unused docker resources

```shell
# Prune every unused docker objects
docker system prune --volumes -f

# Remove dangling volumes
docker volume rm -f $(docker volume ls -f dangling=true)

# Remove exited container
docker rm -f $(docker ps --filter status=exited -q)

# Docker removes dangling (<none> tag) image
docker rmi $(sudo docker images -f "dangling=true" -q)

# Display full content of all tag for container
docker ps --no-trunc -a
```
