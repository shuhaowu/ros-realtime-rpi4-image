#!/bin/bash

filename="data/$(lsb_release -r | awk '{print $2}')_$(uname -r).log"

set -xe

export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get install -y python3-venv fonts-stix
if [ ! -f $HOME/latencytestvenv/bin/activate ]; then
  python3 -m venv ~/latencytestvenv
  source ~/latencytestvenv/bin/activate
  pip3 install -r requirements.txt
else
  source ~/latencytestvenv/bin/activate
fi


python3 cyclictest_latency_plotter.py $filename
