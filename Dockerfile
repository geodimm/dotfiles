FROM ubuntu:focal

RUN apt update && apt -y install \
    cmake \
    software-properties-common \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN echo "Set disable_coredump false" >> /etc/sudo.conf

RUN adduser --disabled-password --gecos '' test && adduser test sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER test

COPY --chown=test:test . /home/test/dotfiles

ENV USER test

ENV PATH="/home/test/bin:${PATH}"

WORKDIR /home/test/dotfiles
