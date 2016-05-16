class check_mk::params {

  # common variables
  $checkmk_service = 'omd'
  $package = 'omd'
  $filestore = undef
  $host_groups= undef
  $site = 'monitoring'
  $workspace = '/root/check_mk'
  $version = '0.56'

  # OS specific variables
  case $::osfamily {
    'RedHat': {
      $httpd_service = 'httpd'
    }
    'Debian': {
      $httpd_service = 'apache2'
    }
    default: {
      fail("OS Family ${::osfamily} is not supported")
    }
  }
}
