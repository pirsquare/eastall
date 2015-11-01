#!/bin/bash
set -euo pipefail

GRAPHITE_INSTALLER='/opt/graphite-installer' # where to place source code for installing
GRAPHITE_HOME='/opt/graphite'
GRAPHITE_RELEASE='0.9.13-pre1'

# Install dependencies
yum install -y python-devel libffi libffi-devel memcached cairo-devel

mkdir ${GRAPHITE_INSTALLER}
cd ${GRAPHITE_INSTALLER}
git clone https://github.com/graphite-project/graphite-web.git
git clone https://github.com/graphite-project/carbon.git
git clone https://github.com/graphite-project/whisper.git

# Build and install Graphite/Carbon/Whisper
cd whisper; git checkout ${GRAPHITE_RELEASE}; python setup.py install
cd ../carbon; git checkout ${GRAPHITE_RELEASE}; pip install -r requirements.txt; python setup.py install
cd ../graphite-web; git checkout ${GRAPHITE_RELEASE}; pip install -r requirements.txt; python check-dependencies.py; python setup.py install

# Remove .example at the end
cd ${GRAPHITE_HOME}/conf
for filename in *.example; do mv "$filename" "${filename/\.example/}"; done

cd ${GRAPHITE_HOME}/webapp/graphite
mv local_settings.py.example local_settings.py

# setup carbon cache daemon
cat <<'EOL' > /etc/systemctl/system/carbon-cache.service
[Unit]
Description=Graphite Carbon Cache Single Instance

[Service]
ExecStartPre=rm -f /opt/graphite/storage/carbon-cache-1.pid # Remove existing pids
ExecStart=/opt/graphite/bin/carbon-cache.py --instance=1 start
Type=forking
PIDFile=/opt/graphite/storage/carbon-cache-1.pid

[Install]
WantedBy=multi-user.target
EOL

chmod 0755 /etc/systemctl/system/carbon-cache.service
systemctl enable carbon-cache
systemctl start carbon-cache
systemctl start memcached
