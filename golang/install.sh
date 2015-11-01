#!/bin/bash
set -euo pipefail

file_exists() {
    [[ -f "$1" ]]
}

DISTRO=
VERSION=${1:-1.5.1} # default version to install if not provided


# Suppported distros
# Debian based - Debian, Ubuntu
# RPM based - Centos, Fedora, RHEL
if file_exists /etc/debian_version; then
    DISTRO='debian'
elif file_exists /etc/redhat-release; then
    DISTRO='rpm'
elif file_exists /etc/system-release; then
    DISTRO='rpm'
else
    echo "Your operating system is not supported at the moment"
    exit
fi


# Environment variables for golang
cat <<'EOL' > /etc/profile.d/golang.sh
export GOROOT=/opt/go
export PATH=$PATH:$GOROOT/bin:/opt/gopackages/thirdparty/bin:/opt/gopackages/local/bin
export GOPATH=/opt/gopackages/thirdparty:/opt/gopackages/local
export GOPATH_THIRDPARTY=/opt/gopackages/thirdparty
export GOPATH_LOCAL=/opt/gopackages/local
EOL


# Install dependencies
if [[ $DISTRO == 'rpm' ]]; then
    yum -y update
    yum install -y gcc gcc-g++ git make mercurial openssl-devel wget tar xz xz-libs
fi

if [[ $DISTRO == 'debian' ]]; then
    apt-get -y update
    apt-get install -y gcc g++ git make mercurial openssl wget tar build-essential
fi


# Install Golang
cd /opt
wget -O /opt/go${VERSION}.linux-amd64.tar.gz https://storage.googleapis.com/golang/go${VERSION}.linux-amd64.tar.gz
tar xzf go${VERSION}.linux-amd64.tar.gz -C /opt

source /etc/profile.d/golang.sh
go get golang.org/x/tools/cmd/... && go get golang.org/x/tools/cmd/godoc

echo ''
echo 'Almost done, logout than login back to complete the installation.'
echo ''
