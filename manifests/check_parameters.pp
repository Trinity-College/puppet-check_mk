define check_mk::check_parameters (
  $description,
  $parameters,
  $hosts,
  $services,
  $order   = 0,
  $tags    = undef,
  $target  = undef,
) {

  $_services = sprintf("[ '%s' ]", join($services, "', '"))
  if $tags {
    $_tags = sprintf("[ '%s' ]", join($tags, "', '"))
  }
  $_hosts = $hosts ? {
    'ALL_HOSTS' => 'ALL_HOSTS',
    default     => sprintf("[ '%s' ]", join($hosts, "', '")),
  }
  $_content = $tags ? {
    undef   => "  ( ${parameters}, ${_hosts}, ${_services} ),\n",
    default => "  ( ${parameters}, ${_tags}, ${_hosts}, ${_services} ),\n",
  }

  concat::fragment { "check_mk-${title}-${::fqdn}":
    target  => $target,
    content => $_content,
    order   => 41 + $order,
  }
}

