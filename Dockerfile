FROM ubuntu:latest

# Install deps
RUN apt-get update && \
apt install -yq build-essential wget pkg-config dumb-init unzip \
libjpeg-dev libpng-dev libtiff-dev xml2 libx264-dev \
frei0r-plugins frei0r-plugins-dev \
libgtk2.0-common libgtk2.0-dev libexif-dev \
libmovit-dev libebur128-dev libsdl2-dev libsox-dev

WORKDIR /tmp/build
ENV LANG="C.UTF-8"
ENV LD_LIBRARY_PATH="/usr/local/lib:/usr/lib"

# Install nasm which is required by ffmpeg
RUN wget -nv https://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.bz2 && \
tar -xf nasm-2.13.03.tar.bz2 && cd nasm-2.13.03 && \
./configure && make -j2 && make install

# Install ffmpeg
RUN wget -nv https://www.ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar -xf ffmpeg-snapshot.tar.bz2 && cd ffmpeg && \
./configure --enable-shared --enable-gpl --enable-libx264 && make -j2 && make install

# Install mltframework
RUN wget -nv https://github.com/mltframework/mlt/archive/master.zip -O mlt-source.zip && \
unzip mlt-source.zip -d mlt-source && cd mlt-source/mlt-master && \
./configure && make -j2 && make install

RUN apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* rm -rf /tmp/build/*

# Create app directory
# WORKDIR /usr/src/app

ENTRYPOINT ["dumb-init", "--", "melt"]
