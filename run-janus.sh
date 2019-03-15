#!/bin/sh

sed -i 's/#stun_server = "stun.voip.eutelia.it"/stun_server = "stun.l.google.com"/g' /usr/local/etc/janus.jcfg
sed -i 's/#stun_port = 3478/stun_port = 19302/g' /usr/local/etc/janus/janus.jcfg
sed -i 's/debug_level = 4/debug_level = 5/g' /usr/local/etc/janus/janus.jcfg
sed -i 's/#debug_timestamps = true/debug_timestamps = true/g' /usr/local/etc/janus/janus.jcfg

sed -i 's/#nat_1_1_mapping = "1.2.3.4"/nat_1_1_mapping = "'${PUBLIC_IP}'"/g' /usr/local/etc/janus/janus.jcfg
sed -i 's/#local_ip = "1.2.3.4"/local_ip = "'${PUBLIC_IP}'"/g' /usr/local/etc/janus/janus.plugin.sip.jcfg
sed -i 's/#sdp_ip = "1.2.3.4"/sdp_ip = "'${PUBLIC_IP}'"/g' /usr/local/etc/janus/janus.plugin.sip.jcfg
sed -i 's/rtp_port_range = "20000-40000"/#rtp_port_range = "20000-40000"/g' /usr/local/etc/janus/janus.plugin.sip.jcfg

ulimit -c unlimited
janus
