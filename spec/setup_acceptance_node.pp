class { 'foreman::repo':
  repo => 'nightly',
}

stdlib::ensure_packages(['podman'])

$container_file = "[Unit]
Description=Advisor Engine
After=network-online.target
[Container]
Image=registry.access.redhat.com/ubi9/python-312
Exec=python /usr/local/bin/python-https-server
Network=host
Volume=/usr/local/bin/python-https-server:/usr/local/bin/python-https-server
[Service]
Restart=always
[Install]
WantedBy=default.target
"

$python_server = "
from http.server import HTTPServer, SimpleHTTPRequestHandler
import ssl
import os

context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile='/opt/app-root/src/cert.pem', keyfile='/opt/app-root/src/key.pem')
context.check_hostname = False

port=int(os.environ.get('IOP_ADVISOR_ENGINE_PORT', 8000))

with HTTPServer(('localhost', port), SimpleHTTPRequestHandler) as httpd:
    httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
    httpd.serve_forever()
"

file { '/etc/containers/systemd/iop-advisor-engine.container':
  ensure  => present,
  content => $container_file,
  require => Package['podman'],
}

file { '/usr/local/bin/python-https-server':
  ensure  => present,
  content => $python_server,
}

file { '/etc/foreman-proxy':
  ensure => directory,
}

group { 'foreman-proxy':
  ensure => present,
}
