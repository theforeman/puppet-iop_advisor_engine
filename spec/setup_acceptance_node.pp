package { 'podman':
  ensure => installed,
}

class { 'foreman::repo':
  repo => 'nightly',
}

file { '/etc/foreman-proxy':
  ensure => directory,
}

group { 'foreman-proxy':
  ensure => present,
}
