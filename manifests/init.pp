# == Class: advisor
#
# Install and configure advisor
#
# === Parameters:
#
class advisor (
) {
  include podman
  include certs::advisor

  $service_name = 'insights-satellite-engine'

  $server_cert_secret_name = "${service_name}-server-cert"
  $server_key_secret_name = "${service_name}-server-key"

  $context = {
    'server_cert_secret_name' => $server_cert_secret_name,
    'server_key_secret_name' => $server_key_secret_name,
  }

  file { '/etc/advisor':
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "/etc/containers/systemd/${service_name}.container.d":
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "/etc/containers/systemd/${service_name}.container.d/10-certs.conf":
    ensure  => file,
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => epp('advisor/10-certs.conf.epp', $context),
    notify  => Service[$service_name],
  }

  podman::secret { $server_cert_secret_name:
    path => $certs::advisor::advisor_server_cert,
  }

  podman::secret { $server_key_secret_name:
    path => $certs::advisor::advisor_server_key,
  }

  service { $service_name:
    ensure => running,
    enable => true,
  }
}
