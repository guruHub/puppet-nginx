# Class: nginx::package
#
# This module manages NGINX package installation
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::package(
  $debian_package = $nginx::params::nx_debian_package
) {
  anchor { 'nginx::package::begin': }
  anchor { 'nginx::package::end': }

  case $::operatingsystem {
    centos,fedora,rhel,redhat: {
      class { 'nginx::package::redhat':
        require => Anchor['nginx::package::begin'],
        before  => Anchor['nginx::package::end'],
      }
    }
    debian,ubuntu: {
      class { 'nginx::package::debian': 
        debian_package => $debian_package,
        require        => Anchor['nginx::package::begin'],
        before         => Anchor['nginx::package::end'],
      }
    }
    opensuse,suse: {
      class { 'nginx::package::suse':
        require => Anchor['nginx::package::begin'],
        before  => Anchor['nginx::package::end'],
      }
    }
  }
}
