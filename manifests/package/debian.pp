# Class: nginx::package::debian
#
# This module manages NGINX package installation on debian based systems
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
class nginx::package::debian(
  $debian_package = $nginx::params::nx_debian_package
) {
  package { $debian_package:
    ensure => present,
  }
}
