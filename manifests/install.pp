class check_mk::install (
  $package = undef,
) {

  $package_name = $package
  package { $package_name:
      ensure => installed,
  }

}
