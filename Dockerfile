# Since oficial image is only for testing hosting built static files
# see: https://github.com/gatsbyjs/gatsby-docker/issues/25#issuecomment-626197455
# see: https://www.stoutlabs.com/blog/2019-02-05-my-docker-setup-gatsby-next/
# And following official image is legacy
# see: https://hub.docker.com/r/gatsbyjs/gatsby-dev-builds
FROM node:18.12.1-alpine3.15

RUN apk add --no-cache \
# git: gatsby new command depends on git
    git \
# util-linux: gatsby develop calls lscpu
# openssl, sudo: gatsby develop --https uses
    util-linux openssl sudo \
# Node-gyp v9.1.0 requires Python3.6.0 or more:
#   #0 58.43 gyp ERR! find Python - version is 2.7.18 - should be >=3.6.0
#   #0 58.43 gyp ERR! find Python - THIS VERSION OF PYTHON IS NOT SUPPORTED
    python3 g++ \
# gatsby-plugin-sharp depends on imagemin-mozjpeg,
# imagemin-mozjpeg depends on mozjpeg,
# mozjpeg requires compiling from source with autoreconf, automake, libtool, gcc, make, musl-dev, file, pkgconfig, nasm
# see: https://pkgs.alpinelinux.org/contents?page=1&file=autoreconf
# see: https://github.com/buffer/pylibemu/issues/24#issuecomment-492759639
# see: https://github.com/maxmind/libmaxminddb/issues/9#issuecomment-30836272
# see: https://stackoverflow.com/questions/28631817/no-acceptable-c-compiler-found-in-path/57419374#57419374
# see: https://pkgs.alpinelinux.org/contents?branch=v3.3&name=file&arch=x86&repo=main
# see: https://stackoverflow.com/questions/17089858/pkg-config-pkg-prog-pkg-config-command-not-found/17106579#17106579
# see: https://github.com/alicevision/AliceVision/issues/593#issuecomment-457194176
    autoconf automake libtool gcc make musl-dev file pkgconfig nasm \
# sharp depends on vips
# see: https://github.com/lovell/sharp/issues/773
# Can't resolve without vips-dev:
#   #0 64.81 ../src/common.cc:24:10: fatal error: vips/vips8: No such file or directory
    vips vips-dev \
 && rm -fR /var/cache/apk/*

# Also exposing VSCode debug ports
# 8000      : For HTTP access for development
# 9000      : For HTTP access for audit
# see: https://www.gatsbyjs.com/tutorial/part-eight/
EXPOSE 8000 9000

# We introduce yarn since it's still faster and isn't found any defintive defects.
# In Gatsby development, gatsby-cli is required.
# When install gatsby-cli in global, we can omit it in package.json.
RUN yarn global add gatsby-cli@4.25.0 && yarn cache clean

WORKDIR /workspace
CMD ["gatsby", "develop", "-H", "0.0.0.0" ]
