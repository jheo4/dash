#!/bin/bash

set -e
base=$(pwd)

mkdir -p $base/Inputs
mkdir -p $base/Outputs
mkdir -p $base/bin
mkdir -p $base/ffmpeg_build

sudo apt-get update -qq && sudo apt-get -y install autoconf automake \
  build-essential cmake git libass-dev libfreetype6-dev libsdl2-dev \
  libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev nasm yasm libx264-dev \
  libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev libmp3lame-dev \
  libopus-dev

if ! [ -f $base/bin/ffmpeg ]; then
  rm -rf $base/bin
  rm -rf $base/ffmpeg_build

  if ! [ -d $base/ffmpeg ]; then
    wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
    tar xjvf ffmpeg-snapshot.tar.bz2
    rm ffmpeg-snapshot.tar.bz2
  fi

  cd ffmpeg && PKG_CONFIG_PATH="$base/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$base/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-libs="-lpthread -lm" \
    --bindir="$base/bin" \
    --enable-gpl \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree && \
    make -j4 && \
    make install
fi
