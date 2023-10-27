# Odoo's installation using Docker compose

## Prerequisite and Installation

Install docker and docker compose

- [Docker](https://docs.docker.com/engine/install/)

- [Docker compose plugin](https://docs.docker.com/compose/install/linux/)

- [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/)

## Running Odoo

1. Clone this project to your computer

    ```shell
    ODOO_DOCKER_PATH=$HOME/odoo-docker
    git clone https://github.com/xmars4/odoo-docker -b 16 --depth=1 $ODOO_DOCKER_PATH
    ```

2. Copy custom addons to folder **custom-addons**

3. Copy enterprise addons to folder **et-addons**

4. Edit confile file [etc/odoo.conf](etc/odoo.conf) if you want to add or update some configurations

5. Running Odoo

    ```shell
    cd $ODOO_DOCKER_PATH
    docker compose build --pull
    docker compose -p dev up -d 
    ```

6. DONE, your Odoo instance will run on [http://localhost:18069](http://localhost:18069)

7. _(Optionally)_ Setup log rotate (on host machine)

    ```shell
    cd $ODOO_DOCKER_PATH/scripts
    sudo /bin/bash setup-logrotate.sh
    ```

8. _(Optionally)_ If you want to add extra command when run odoo

- With this option, you can run arbitrary odoo commands
- for instance:

    - Add **_command_** param to [etc/odoo.conf](etc/odoo.conf) file

        ```confile
        ...
        command = -i stock -u sale_management
        ```

    - Restart services

        ```shell
        docker compose restart
        ```

## How to build and publish customized Odoo image on Docker hub

1. Pull latest Odoo image

    ```shell
    docker pull odoo:16
    ```

2. Run build command

    ```shell
    cd $ODOO_DOCKER_PATH/dockerfile
    docker build -f Dockerfile --pull -t xmars/odoo:16 .
    ```

3. _(Optionally)_ Push newly image to Docker hub

    ```shell
    docker login
    docker push xmars/odoo:16
    ```

4. _(Optionally)_ if you want to install some libs, edit [dockerfile/requirements.txt](dockerfile/requirements.txt) and [dockerfile/entrypoint.sh](dockerfile/entrypoint.sh) and rebuild the image

## Tip and Tricks

- [generate records for testing](https://www.odoo.com/documentation/16.0/developer/reference/cli.html#database-population)

```shell
  docker exec <odoo_container_name_or_id> odoo populate --models res.partner,product.product --size medium -c /etc/odoo/odoo.conf
```

- run postgresql by docker

```shell
docker run --name postgresql-15 -p 5432:5432 \
 -e POSTGRES_USER=admin \
 -e POSTGRES_PASSWORD=admin \
 -e POSTGRES_DB=postgresdb \
 -d --restart unless-stopped \
 postgres:15
```

- Clean docker resources

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

- Test logrotate works properly

```shell
sudo /usr/sbin/logrotate /etc/logrotate.conf -v
```

## Problems and Solutions

- Run multiple docker compose with the same config in the same folder name, the new one will override the others,

    \*\* Solution

    Add **-p \<project-name\>** option to docker compose run to diffentiate them

    ```shell
        docker compose -p <project-name> up -d
    ```

- If you run docker compose in Windows and got problem

    ```shell
    entrypoint.sh file not found
    ```

    \*\* Solution:

    - open file this project in [VSCode](https://code.visualstudio.com/download)
        or [Pycharm](https://www.jetbrains.com/pycharm/download/)

    - make sure encoding option and line separator is correct

        ![alt](img/encoding-problem.png)
