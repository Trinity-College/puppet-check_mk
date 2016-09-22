define check_mk::parent (
  $host_tags,
  $order  = 0,
  $target = undef,
) {

  $_tags = sprintf("['%s']", join($host_tags, "', '"))

  $_content = "  ( '${name}', ${_tags}, ALL_HOSTS ),\n"

  concat::fragment { "check_mk-${title}":
    target  => $target,
    content => $_content,
    order   => 31 + $order,
  }
}

