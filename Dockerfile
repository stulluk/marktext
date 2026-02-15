# MarkText Linux (amd64) build image: Node 16 + electron-builder + deps for .deb/AppImage/rpm
FROM node:16-bullseye

ARG UID=1000
ARG GID=1000
ARG USER=build
ENV DEBIAN_FRONTEND=noninteractive
ENV MARKTEXT_IS_STABLE=1
ENV DISPLAY=:99.0

# electron-builder + native modules (keytar, keyboard-layout, fontmanager) + rpm for .rpm
RUN apt-get update && apt-get install -y --no-install-recommends \
    icnsutils \
    graphicsmagick \
    xz-utils \
    libx11-dev \
    libxkbfile-dev \
    gnome-keyring \
    libsecret-1-dev \
    libfontconfig-dev \
    rpm \
    xvfb \
    libgtk-3-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# node:16-bullseye includes yarn; ensure it's available
RUN command -v yarn >/dev/null 2>&1 || npm install -g yarn@1.22.19 --force

WORKDIR /workspace

# When run via indockerbuild.sh, host passes: cd ${TOPDIR} && time ./builder.sh ${TOPDIR}
# Default CMD for manual runs with -v and -w set to repo:
CMD ["./builder.sh", "."]
