## How to use
```shell
curl https://raw.githubusercontent.com/pirsquare/eastall/master/graphite/install.sh | sudo bash
cd /opt/graphite/webapp/graphite
python manage.py syncdb
python manage.py runserver
```


## Details

This is **not** a full complete version of graphite installation, I won't recommend anyone to use it yet.


## Requirements
You need python and pip installed.


## Todo
- Add statsd installation
- Add nginx installation
- Add supervisord to manage graphite webapp
- Add support for more distros


## Supported distros
- Centos 7
