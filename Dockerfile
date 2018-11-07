FROM kyleehee/melt:latest

# Install deps
RUN apt-get update && \
apt install -yq qt5-default libqt5webkit5-dev xvfb

WORKDIR /tmp/build

RUN wget -nv https://github.com/mltframework/mlt/archive/master.zip -O mlt-source.zip && \
unzip mlt-source.zip -d mlt-source

# Install webvfx for mlt
RUN wget -nv https://github.com/mltframework/webvfx/archive/master.zip -O webvfx-source.zip && \
unzip webvfx-source.zip -d webvfx-source && cd webvfx-source/webvfx-master && \
qmake -r PREFIX=/usr/local MLT_SOURCE=/tmp/build/mlt-source/mlt-master && make && make install

RUN apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/build/*

WORKDIR /usr/src/app
COPY start.sh .
RUN chmod a+x start.sh
ENV DISPLAY :99

ENTRYPOINT ["dumb-init", "--", "/usr/src/app/start.sh"]
CMD ["dumb-init", "--", "/usr/src/app/start.sh"]
