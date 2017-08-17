# check_mk

Puppet module for:

* Installing and configuring check_mk agents

Agent hostnames are automatically added to the server all_hosts configuration
using stored configs.

Upstream had morphed into an OMD module, but without re-naming it as such.
This fork is to only be concerned with check-mk, assuming users have an
existing nagios install they are trying to extend.

## Server

* Installs check-mk package(s) using the system repository (eg. yum, apt)

* Populates the all_hosts array in /etc/check_mk/main.mk with hostnames
  exported by check::agent classes on agent hosts

### Example 1

    include check_mk

Installs the 'monitoring' package from the system repository.


### check_mk parameters

*package*: The check_mk_server package (rpm or deb) to install.

*host_groups*: A hash with the host group names as the keys with a list of host tags to match as values. (See 'Host groups and tags' below). Optional.

### Notes


## Agent

* Installs the check_mk-agent package.

* Configures the /etc/xinetd.d/check_mk configuration file

### Example 1

    include check_mk::agent

Installs the check_mk package from the system repository
and configures /etc/xinetd.d/check_mk with no IP whitelist restrictions.

### Example 2

    class { 'check_mk::agent':
      version => '1.2.0p3-1',
      ip_whitelist => [ '10.7.96.21', '10.7.96.22' ],
    }

Installs the specified versions of the check_mk package
after retrieving them from the Puppet file store.  Configures
/etc/xinetd.d/check_mk so that only the specified IPs (and localhost/127.0.0.1)
are allowed to connect.

### check_mk::agent parameters

*ip_whitelist*: The list of IP addresses that are allowed to retrieve check_mk
data. (Note that localhost is always allowed to connect.) By default any IP can
connect.

*port*: The port the check_mk agent listens on. Default: '6556'

*server_dir*: The directory in which the check_mk_agent executable is located.
Default: '/usr/bin'

*use_cache*: Whether or not to cache the results - useful with redundant
monitoring server setups.  Default: 'false'

*user*: The user that the agent runs as. Default: 'root'

*mrpe_checks*: Specifies a hash of check_mk::agent::mrpe resources to create. Default: {}

## Host groups and tags

By default check_mk puts all hosts into a group called 'check_mk' but where you
have more than a few you will often want your own groups.  We can do this by
setting host tags on the agents and then configuring host groups on the server
side to match hosts with these tags.

For example in the hiera config for your agent hosts you could have:

    check_mk::agent::host_tags:
      - '%{osfamily}'

and on the monitoring host you could have:

    check_mk::host_groups:
      RedHat:
        description: 'RedHat or_CentOS hosts'
        host_tags:
          - RedHat
      Debian:
        description: 'Debian or Ubuntu_hosts'
        host_tags:
          - Debian
      SuSE:
        description: 'SuSE hosts'
        host_tags:
          - Suse

You can of course have as many host tags as you like. I have custom facts for
the server role and the environment type (dev, qa, stage, prod) and define
groups based on the role and envtype host tags.

Remember to run the Puppet agent on your agent hosts to export any host tags
and run the Puppet agent on the monitoring host to pick up any changes to the
host groups.

## Static host config

Hosts that do not run Puppet with the check_mk module needs to get added to hiera.
check_mk::config creates the config file /etc/check_mk/all_hosts_static from a template.
The template will look for hiera variables.
The hiera variable check_mk::all_hosts_static has to be an array:

check_mk::all_hosts_static:
  - host1.domain
  - host2.domain


You can also include host tags - for example:

check_mk::all_hosts_static:
  - host1.domain|windows|dev,
  - host2.domain|windows|prod,

