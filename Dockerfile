FROM golang:1.21.5
ARG version=7.7.2
RUN apt-get update  && apt-get install -y libfreetype6-dev tcllib tcl tcl-dev tklib tk tk-dev libglew-dev 
RUN rm -rf /var/lib/apt/lists/*
WORKDIR /tmp

# ///download/official-upstream-packages/opencascade-7.5.0.tgz
# https://download.njuu.cf/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_7_2.tar.gz
RUN wget https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V$(echo $version | sed 's/\./_/g').tar.gz
# RUN wget https://download.njuu.cf/Open-Cascade-SAS/OCCT/archive/refs/tags/V$(echo $version | sed 's/\./_/g').tar.gz
RUN tar -zxvf V$(echo $version | sed 's/\./_/g').tar.gz
RUN mkdir -p /opt/build/
RUN mv OCCT-$(echo $version | sed 's/\./_/g') /opt/build/occt772static
RUN mkdir -p /opt/build/occt772static/build 

WORKDIR /opt/build/occt772static/build
RUN apt-get update  && apt-get install -y cmake
RUN cmake \
  -DCMAKE_SIZEOF_VOID_P=8 \
  -DINSTALL_DIR=/opt/build/occt772static \
  -DBUILD_RELEASE_DISABLE_EXCEPTIONS=OFF \
  -DBUILD_LIBRARY_TYPE="Static" \
  -DBUILD_MODULE_Draw=OFF \
  -DBUILD_MODULE_DETools=OFF \
  ..

RUN make -j$(nproc) && make install
