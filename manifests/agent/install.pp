class check_mk::agent::install (
  $package   = undef,
) inherits check_mk::agent {
  if ! defined(Package['xinetd']) {
    package { 'xinetd':
      ensure => present,
    }
  }
  $check_mk_agent = $package ? {
    undef => $::osfamily ? {
      'Debian' => 'check-mk-agent',
      'RedHat' => 'check-mk-agent',
      default  => 'check_mk-agent',
    },
    default  => $package,
  }
  package { 'check_mk-agent':
    ensure  => present,
    name    => $check_mk_agent,
    require => Package['xinetd'],
  }
}
