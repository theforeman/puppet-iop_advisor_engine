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

  $service_name = 'advisor-engine'

  $server_cert_secret_name = "${service_name}-server-cert"
  $server_key_secret_name = "${service_name}-server-key"
  $server_ca_cert_secret_name = "${service_name}-server-ca-cert"

  $client_cert_secret_name = "${service_name}-client-cert"
  $client_key_secret_name = "${service_name}-client-key"
  $client_ca_cert_secret_name = "${service_name}-client-ca-cert"

  $context = {
    'server_cert_secret_name'    => $server_cert_secret_name,
    'server_key_secret_name'     => $server_key_secret_name,
    'server_ca_cert_secret_name' => $server_ca_cert_secret_name,
    'client_cert_secret_name'    => $client_cert_secret_name,
    'client_key_secret_name'     => $client_key_secret_name,
    'client_ca_cert_secret_name' => $client_ca_cert_secret_name,
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
    path => $certs::advisor::server_cert,
  }

  podman::secret { $server_key_secret_name:
    path => $certs::advisor::server_key,
  }

  podman::secret { $server_ca_cert_secret_name:
    path => $certs::advisor::server_ca_cert,
  }

  podman::secret { $client_cert_secret_name:
    path => $certs::advisor::client_cert,
  }

  podman::secret { $client_key_secret_name:
    path => $certs::advisor::client_key,
  }

  podman::secret { $client_ca_cert_secret_name:
    path => $certs::advisor::client_ca_cert,
  }

  service { $service_name:
    ensure => running,
    enable => true,
  }
}
