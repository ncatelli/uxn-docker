FROM debian:bullseye

LABEL maintainer="Nate Catelli <ncatelli@packetfire.org>"
LABEL description="A wrapper container for uxn."

ARG UID=1000
ARG GID=1000
ARG RELEASE_URL="https://rabbits.srht.site/uxn/uxn-essentials-lin64.tar.gz"
ENV RELEASE_URL=${RELEASE_URL}
ENV RELEASE=${RELEASE}
ENV USERNAME=uxn

RUN addgroup --system --gid ${GID} ${USERNAME} \
    && useradd -g ${USERNAME} -u ${UID} ${USERNAME}

COPY scripts/vnc.sh /tmp/vnc.sh 

RUN chmod +x /tmp/vnc.sh \
    && /tmp/vnc.sh \
    && rm /tmp/vnc.sh

RUN apt-get update \
    && apt-get install -y curl libsdl2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/

RUN cd /tmp/ \
    && curl -L -o uxn.tar.gz ${RELEASE_URL} \
    && tar -zxvf uxn.tar.gz \
    && rm  uxn.tar.gz \
    && cd uxn/ \
    && mv *.rom /home/uxn/ \
    && mv uxn* /usr/local/bin/ \
    && cd ../ \
    && rm -rf uxn \
    && ls -lah

USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD [ "/usr/local/bin/uxnemu" ]
