FROM debian:bullseye AS builder
ARG RELEASE_URL="https://rabbits.srht.site/uxn/uxn-essentials-lin64.tar.gz"
ENV RELEASE_URL=${RELEASE_URL}

RUN apt-get update \
    && apt-get install -y curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/

RUN cd /tmp/ \
    && curl -L -o uxn.tar.gz ${RELEASE_URL} \
    && tar -zxvf uxn.tar.gz \
    && rm uxn.tar.gz

FROM debian:bullseye 
LABEL maintainer="Nate Catelli <ncatelli@packetfire.org>"
LABEL description="A wrapper container for uxn."

ARG UID=1000
ARG GID=1000
ARG USERNAME=uxn
ENV USERNAME=${USERNAME}

# Setup demo environment variables
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_DIMENSIONS=1024x768 \
    RUN_FLUXBOX=yes

RUN addgroup --system --gid ${GID} ${USERNAME} \
    && useradd -m -g ${USERNAME} -u ${UID} ${USERNAME}

RUN apt-get update \
    && apt-get install -y \
    libsdl2-dev \
    fluxbox \
    net-tools \
    novnc \
    supervisor \
    x11vnc \
    xterm \
    xvfb \
    && apt-get clean && rm -rf /var/lib/apt/lists/

COPY ./entrypoint.sh /entrypoint.sh
COPY ./supervisord /supervisord
COPY --from=builder /tmp/uxn/uxn* /usr/local/bin/

USER ${USERNAME}

RUN mkdir -p /home/${USERNAME}/roms/
COPY --from=builder /tmp/uxn/*.rom /home/${USERNAME}/roms/

WORKDIR /home/${USERNAME}

CMD ["bash", "/entrypoint.sh"]
EXPOSE 6080
