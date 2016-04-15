class check_mk (
  $checkmk_service  = $check_mk::params::checkmk_service,
  $filestore        = $check_mk::params::filestore,
  $host_groups      = $check_mk::params::host_groups,
  $httpd_service    = $check_mk::params::httpd_service,
  $package          = $check_mk::params::package,
  $site             = $check_mk::params::site,
  $workspace        = $check_mk::params::workspace,
  $version          = $check_mk::params::version,
) inherits check_mk::params {

  class { 'check_mk::install':
    filestore => $filestore,
    package   => "${package}-${version}",
    site      => $site,
    workspace => $workspace,
  } ->
  class { 'check_mk::config':
    host_groups => $host_groups,
    site        => $site,
  } ~>
  class { 'check_mk::service':
    checkmk_service => "${checkmk_service}-${version}",
    httpd_service   => $httpd_service,
  }
}
