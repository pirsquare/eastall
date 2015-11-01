#!/bin/bash
# Will install python2.7 on older versions of RPM based distros
set -euo pipefail

command_exists() {
    type "$1" &> /dev/null ;
}

# Get major and minor version of python without dots. Python 2.7 would yield "27"
PYTHON_VERSION=$(python --version 2>&1 | cut -f 2 -d ' ' | cut -f 1,2 -d '.' | sed 's/\.//')

if command_exists python2.7; then
    echo "Python 2.7 already exist"
    exit
fi

if [[ PYTHON_VERSION -ge '27' ]]; then
    echo "Python version is already greater than or equal 2.7"
    exit
fi


# Install dependencies
yum -y update
yum install -y zlib-devel openssl-devel sqlite-devel bzip2-devel wget tar xz xz-libs \
gcc gcc-g++ git make libselinux-python python-argparse


# Install python
cd /tmp
wget http://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz
xz -d Python-2.7.9.tar.xz && tar -xvf Python-2.7.9.tar
cd Python-2.7.9
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared && make && make altinstall
echo '/usr/local/lib' >> '/etc/ld.so.conf' && ldconfig

# Install setuptools and pip
cd /tmp
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz
tar -xvf setuptools-1.4.2.tar.gz
cd setuptools-1.4.2
python2.6 setup.py install
python2.7 setup.py install
easy_install-2.6  pip
easy_install-2.7  pip

