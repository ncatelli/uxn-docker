FROM debian:bullseye

LABEL maintainer="Nate Catelli <ncatelli@packetfire.org>"
LABEL description="A wrapper container for uxn."

ARG UID=1000
ARG GID=1000
ARG RELEASE_URL="https://rabbits.srht.site/uxn/uxn-essentials-lin64.tar.gz"
ENV RELEASE_URL=${RELEASE_URL}
ENV USERNAME=uxn

RUN addgroup --system --gid ${GID} ${USERNAME} \
    && useradd -m -g ${USERNAME} -u ${UID} ${USERNAME}

COPY ./entrypoint.sh /entrypoint.sh
COPY ./supervisord /supervisord

# Setup demo environment variables
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_DIMENSIONS=1024x768 \
    RUN_FLUXBOX=yes

RUN apt-get update \
    && apt-get install -y \
    curl \
    libsdl2-dev \
    fluxbox \
    net-tools \
    novnc \
    supervisor \
    x11vnc \
    xterm \
    xvfb \
    && apt-get clean && rm -rf /var/lib/apt/lists/

RUN cd /tmp/ \
    && curl -L -o uxn.tar.gz ${RELEASE_URL} \
    && tar -zxvf uxn.tar.gz \
    && rm  uxn.tar.gz \
    && cd uxn/ \
    && mkdir -p /home/${USERNAME}/roms/ \
    && mv *.rom /home/${USERNAME}/roms/ \
    && mv uxn* /usr/local/bin/ \
    && cd ../ \
    && rm -rf uxn \
    && ls -lah

USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD ["bash", "/entrypoint.sh"]
EXPOSE 6080