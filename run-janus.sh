#!/bin/sh

RUN sed -i 's/#nat_1_1_mapping = "1.2.3.4"/nat_1_1_mapping = "'${PUBLIC_IP}'"/g' /usr/local/etc/janus/janus.jcfg
RUN sed -i 's/#local_ip = "1.2.3.4"/local_ip = "'${PUBLIC_IP}'"/g' /usr/local/etc/janus/janus.plugin.sip.jcfg
RUN sed -i 's/#sdp_ip = "1.2.3.4"/sdp_ip = "'${PUBLIC_IP}'"/g' /usr/local/etc/janus/janus.plugin.sip.jcfg
ulimit -c unlimited
janus
