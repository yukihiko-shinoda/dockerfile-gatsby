<!-- markdownlint-disable first-line-h1 -->
[![docker build automated?](https://img.shields.io/docker/cloud/automated/futureys/gatsby.svg)](https://hub.docker.com/r/futureys/gatsby/builds)
[![docker build passing?](https://img.shields.io/docker/cloud/build/futureys/gatsby.svg)](https://hub.docker.com/r/futureys/gatsby/builds)
[![image size and number of layers](https://images.microbadger.com/badges/image/futureys/gatsby.svg)](https://hub.docker.com/r/futureys/gatsby/dockerfile)

# Quick reference

- **Maintained by**: [Yukihiko Shinoda](https://github.com/yukihiko-shinoda)

# Quick reference (cont.)

- **Where to file issues**: [https://github.com/yukihiko-shinoda/dockerfile-gatsby/issues](https://github.com/yukihiko-shinoda/dockerfile-gatsby/issues)

- **Image updates**: [Dockerfile](https://github.com/yukihiko-shinoda/dockerfile-gatsby/blob/master/Dockerfile)

- **Source of this description**: [docs repo's root directory](https://github.com/yukihiko-shinoda/dockerfile-gatsby)

<!-- markdownlint-disable no-trailing-punctuation -->
# What is Gatsby?
<!-- markdownlint-enable no-trailing-punctuation -->

[Gatsby Official image](https://hub.docker.com/r/gatsbyjs/gatsby) doesn't actually provide Gatsby in a way that can be used for development via Docker.

cf. [CLI / Dev image · Issue #25 · gatsbyjs/gatsby-docker](https://github.com/gatsbyjs/gatsby-docker/issues/25)

This image provides develop environment which supports:

- [gatsby new](https://www.gatsbyjs.com/docs/gatsby-cli/#new)
- [gatsby develop](https://www.gatsbyjs.com/docs/gatsby-cli/#develop)
- [gatsby develop --https](https://www.gatsbyjs.com/docs/gatsby-cli/#develop)
- [gatsby-plugin-sharp](https://www.gatsbyjs.com/plugins/gatsby-plugin-sharp/)

---

Gatsby is a React-based open source framework for creating websites and apps.
Build anything you can imagine with over 2000 plugins
and performance, scalability, and security built-in by default.

# How to use this image

To run `gatsby new`:

```console
docker run --rm -v $(pwd -W):/workspace futureys/gatsby gatsby new <site-name> [<starter-url>]
```

Ex:

```console
docker run --rm -v $(pwd -W):/workspace futureys/gatsby gatsby new hello-world-gatsby  https://github.com/gatsbyjs/gatsby-starter-hello-world
```

To start development, see [via docker-compose](#-via-docker-compose).

## ... via docker-compose

1\.

Add `Dockerfile` in your project to prevent to repeat installing node packages:

```Dockerfile
FROM futureys/gatsby
COPY ./package.json ./yarn.lock ./
RUN yarn install && yarn cache clean
COPY . .
```

2\.

Add `docker-compose.yml` in your project to define run parameters:

```yaml
version: "3.8"
services:
  web:
    build:
      context: .
    environment:
      # Gatsby also uses NODE_ENV but how effect it is not clear...
      # see: https://www.gatsbyjs.com/docs/environment-variables/
      NODE_ENV: development
    ports:
      # For gatsby develop
      - "8000:8000"
      # For gatsby serve
      - "9000:9000"
      # 9230, 9929: When start multiple instances of node app,
      #       first instance starts occupies 127.0.0.1:9229 and other instances cannot get to the port
      # see: https://dev.to/wataash/chrome-attach-debug-with-webstorm-328p
      # see: https://github.com/nodejs/node-inspect/issues/48#issuecomment-507889953
      - "9230:9230"
      - "9929:9929"
    volumes:
      # see: https://stackoverflow.com/questions/29181032/add-a-volume-to-docker-but-exclude-a-sub-folder/37898591#37898591
      - /workspace/node_modules
      - .:/workspace
```

3\.

Update scripts `develop` and `serve` in `pacage.json` to make it accessible from outside the container:

```Diff
-    "develop": "gatsby develop",
+    "develop": "gatsby develop --host=0.0.0.0",

-    "serve": "gatsby serve,
+    "serve": "gatsby serve --host=0.0.0.0",
```

## ... with Visual Studio Code

Requirement:

- Install [Remote Development extension pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

At first, follow the steps 1. to 3. of [via docker-compose](#-via-docker-compose).

4\.

Select `Remote-Containers: Add Development Container Configuration Files...` to add configuration files for [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers).

5\.

Add Prettier, ESLint, and your using extension to `.devcontainer/devcontainer.json`.

Ex:

```json
    "extensions": [
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
    ]
```

6\.

Run the Remote-Containers: Reopen in Container... command from the Command Palette (F1) or quick actions Status bar item.

cf: [Developing inside a Container using Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/containers)

# License

View license information for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
