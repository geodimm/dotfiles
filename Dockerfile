FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update\
    && apt-get --no-install-recommends -y install \
    sudo \
    build-essential \
    software-properties-common \
    && apt-add-repository -y ppa:git-core/ppa \
    && apt-get update \
    && apt-get --no-install-recommends -y install git \
    && rm -rf /var/lib/apt/lists/*

RUN echo "Set disable_coredump false" >> /etc/sudo.conf

RUN adduser --disabled-password --gecos '' test && adduser test sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER test

COPY --chown=test:test . /home/test/dotfiles

ENV USER test

ENV PATH="/home/test/bin:${PATH}"

WORKDIR /home/test/dotfiles
