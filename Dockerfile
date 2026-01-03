# Since oficial image is only for testing hosting built static files
# see: https://github.com/gatsbyjs/gatsby-docker/issues/25#issuecomment-626197455
# see: https://www.stoutlabs.com/blog/2019-02-05-my-docker-setup-gatsby-next/
# And following official image is legacy
# see: https://hub.docker.com/r/gatsbyjs/gatsby-dev-builds
FROM node:22.13.1-alpine3.20

# - DL3018 is reported when locking apk packageversion by `~` (tilde) · Issue #1165 · hadolint/hadolint
#   https://github.com/hadolint/hadolint/issues/1165
# hadolint ignore=DL3018
RUN apk add --no-cache \
    # gatsby new command depends on git
    git~2.45.4 \
    # gatsby develop calls lscpu
    util-linux~2.40.1 \
    # gatsby develop --https uses
    openssl~3.3.5 \
    # gatsby develop --https uses
    sudo~1.9.15_p5 \
    # Node-gyp v9.1.0 requires Python3.6.0 or more:
    #   #0 58.43 gyp ERR! find Python - version is 2.7.18 - should be >=3.6.0
    #   #0 58.43 gyp ERR! find Python - THIS VERSION OF PYTHON IS NOT SUPPORTED
    python3~3.12.12 \
    g++~13.2.1_git20240309 \
    # gatsby-plugin-sharp depends on imagemin-mozjpeg,
    # imagemin-mozjpeg depends on mozjpeg,
    # mozjpeg requires compiling from source with autoreconf, automake, libtool, gcc, make, musl-dev, file, pkgconfig, nasm
    # - Package index - Alpine Linux packages
    #   https://pkgs.alpinelinux.org/contents?page=1&file=autoreconf
    autoconf~2.72 \
    # - Error with install: autoreconf fails to run aclocal · Issue #24 · buffer/pylibemu
    #   https://github.com/buffer/pylibemu/issues/24#issuecomment-492759639
    automake~1.16.5 \
    # - undefined macro: AC_PROG_LIBTOOL · Issue #9 · maxmind/libmaxminddb
    #   https://github.com/maxmind/libmaxminddb/issues/9#issuecomment-30836272
    libtool~2.4.7 \
    # - Answer: macos - No acceptable C compiler found in $PATH - Stack Overflow
    #   https://stackoverflow.com/a/57419374/12721873
    gcc~13.2.1_git20240309 \
    make~4.4.1 \
    musl-dev~1.2.5 \
    # - Package index - Alpine Linux packages
    #   https://pkgs.alpinelinux.org/contents?file=file&path=&name=&branch=v3.15&repo=main&arch=x86
    file~5.45 \
    # - Answer: macos - pkg-config: PKG_PROG_PKG_CONFIG: command not found - Stack Overflow
    #   https://stackoverflow.com/a/17106579/12721873
    pkgconfig~1.9.4 \
    # - Build error: no nasm (Netwide Assembler) found · Issue #593 · alicevision/AliceVision
    #   https://github.com/alicevision/AliceVision/issues/593#issuecomment-457194176
    nasm~2.16.03 \
    # sharp depends on vips
    # - Error loading shared library libvips-cpp.so.42: No such file or directory · Issue #773 · lovell/sharp
    #   https://github.com/lovell/sharp/issues/773
    vips~8.15.2 \
    # Can't resolve without vips-dev:
    #   #0 64.81 ../src/common.cc:24:10: fatal error: vips/vips8: No such file or directory
    vips-dev~8.15.2 \
 && rm -fR /var/cache/apk/*

# Also exposing VSCode debug ports
# 8000      : For HTTP access for development
# 9000      : For HTTP access for audit
# see: https://www.gatsbyjs.com/tutorial/part-eight/
EXPOSE 8000 9000

# We introduce yarn since it's still faster and isn't found any defintive defects.
# In Gatsby development, gatsby-cli is required.
# When install gatsby-cli in global, we can omit it in package.json.
RUN yarn global add gatsby-cli@5.15.0 && yarn cache clean

WORKDIR /workspace
CMD ["gatsby", "develop", "-H", "0.0.0.0" ]
