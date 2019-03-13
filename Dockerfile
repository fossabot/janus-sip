## Install build essential

FROM ubuntu:16.04


RUN   mkdir -p /var/connector
ADD . /var/connector/

RUN  apt-get clean
RUN  apt-get update
RUN  apt-get install -y make vim wget git


RUN  apt-get update &&  \
     apt-get install -y cron \
     libmicrohttpd-dev \
     libjansson-dev  \
     gtk-doc-tools  \
     libssl-dev \
     libsrtp-dev \
     libsofia-sip-ua-dev  \
     libglib2.0-dev \
     libopus-dev \
     libogg-dev \
     libcurl4-openssl-dev \ 
     libavutil-dev \
     libavcodec-dev \
     libavformat-dev \
     pkg-config \
     gengetopt \
     libtool \
     automake \
     cmake \
     libconfig-dev \
     pkg-config \
     gnutls-bin \
     lsof wget vim sudo 

RUN LIBWEBSOCKET="3.1.0" && wget https://github.com/warmcat/libwebsockets/archive/v$LIBWEBSOCKET.tar.gz && \
    tar xzvf v$LIBWEBSOCKET.tar.gz && \
    cd libwebsockets-$LIBWEBSOCKET && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" -DLWS_MAX_SMP=1 -DLWS_IPV6="ON" .. && \
    make && make install


RUN SRTP="2.2.0" && apt-get remove -y libsrtp0-dev && wget https://github.com/cisco/libsrtp/archive/v$SRTP.tar.gz && \
    tar xfv v$SRTP.tar.gz && \
    cd libsrtp-$SRTP && \
    ./configure --prefix=/usr --enable-openssl && \
    make shared_library && sudo make install

RUN git clone https://gitlab.freedesktop.org/libnice/libnice.git && \
    cd libnice && \
    git checkout 67807a17ce983a860804d7732aaf7d2fb56150ba && \
    bash autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install

RUN cd /var/connector && git clone https://github.com/etherlabsio/janus-sip.git && cd /var/connector/janus-sip && \
    sh autogen.sh &&  \
    git checkout origin/sipgwconnector && \
    ./configure  \
    --disable-rabbitmq  \
    --disable-mqtt  \
    --disable-unix-sockets  \
    --enable-plugin-sip  \
    --disable-docs  \
    --disable-plugin-audiobridge \
    --disable-plugin-videocall \
    --disable-plugin-videoroom  && \
    make && make install && make configs && ldconfig

COPY /var/connector/janus-sip/run_janus.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run_janus.sh
RUN sudo sed -i 's/#stun_server = "stun.voip.eutelia.it"/stun_server = "stun.l.google.com"/g' /usr/local/etc/janus.jcfg
RUN sed -i 's/#stun_port = 3478/stun_port = 19302/g' /usr/local/etc/janus/janus.jcfg
RUN sed -i 's/#debug_timestamps = true/debug_timestamps = true/g' /usr/local/etc/janus/janus.jcfg

#CMD janus

CMD ["sh", "-c", "/usr/local/bin/run_janus.sh"]

EXPOSE 80 443
EXPOSE 10000-60000:10000-60000/udp
