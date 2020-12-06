FROM debian:stable-slim

RUN apt-get update \
    && apt-get -y --no-install-recommends install ca-certificates python3 curl unzip git \
                  orthanc orthanc-dicomweb orthanc-mysql orthanc-webviewer \
                  build-essential cmake libcurl4-openssl-dev libssl-dev zlib1g-dev \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && mkdir /app

WORKDIR /app
RUN curl -L https://github.com/radpointhq/orthanc-s3-storage/archive/master.tar.gz -o orthanc-s3.tar.gz \
    && tar zxvf orthanc-s3.tar.gz \
    && cmake -DCMAKE_INSTALL_PREFIX="/usr" \
         -DCMAKE_BUILD_TYPE=Debug \
         -DCMAKE_CXX_STANDARD=14 \
         -DCMAKE_CXX_STANDARD_REQUIRED="ON" \
         -DALLOW_DOWNLOADS="ON" \
         -DSTANDALONE_BUILD="ON" \
         -DSTATIC_BUILD="OFF" \
         -DUSE_SYSTEM_BOOST="OFF" \
         -DUSE_SYSTEM_CURL="ON" \
         -DUSE_SYSTEM_SSL="ON" \
         -DUSE_SYSTEM_LIBZ="ON" \
         -DUSE_SYSTEM_MONGOOSE="OFF" \
         -DUSE_SYSTEM_PUGIXML="OFF" \
         -DUSE_SYSTEM_GOOGLE_TEST="OFF" \
         -DUSE_SYSTEM_UUID="OFF" \
         -DUSE_SYSTEM_DCMTK="OFF" \
         -DUSE_SYSTEM_JSONCPP="OFF" \
         -DUSE_SYSTEM_ORTHANC_SDK="OFF" \
         -DUSE_SYSTEM_AWS_SDK="OFF" \
         -S orthanc-s3-storage-master -B build \
    && cd build \
    && cmake --build . -- -j6 \
    && cmake --build . --target install

RUN apt-get -y --no-install-recommends install python3-pip \
    && python -m pip install supervisor setuptools

RUN rm -rf /app/* \
    && apt-get -y remove build-essential cmake libcurl4-openssl-dev libssl-dev zlib1g-dev git \
    && apt-get -y autoremove

ADD . /app
ADD supervisord.conf /etc/supervisord.conf
RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]
