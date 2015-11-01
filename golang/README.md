## How to use
```shell
# If you want to install default version
curl https://raw.githubusercontent.com/pirsquare/eastall/master/golang/install.sh | sudo bash

# If you want to specify the version that you want to install, pass version number as argument
# To see various Golang's version, see https://golang.org/dl/
# For example, to install Golang 1.4.3
curl https://raw.githubusercontent.com/pirsquare/eastall/master/golang/install.sh | sudo bash -s 1.4.3
```

## Details
- Installs Golang 1.5.1 by default (can be overridden)
- Uses /opt/gopackages/thirdparty to store third party golang packages
- Uses /opt/gopackages/local to store local golang packages

## Supported distros
- Centos
- Fedora
- RHEL
- Ubuntu
- Debian
