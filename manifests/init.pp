class check_mk (
  $host_groups      = $check_mk::params::host_groups,
  $package          = $check_mk::params::package,
) inherits check_mk::params {

  class { 'check_mk::install':
    package   => $package,
  }
  class { 'check_mk::config':
    host_groups => $host_groups,
    require     => Class['check_mk::install'],
  }
}
