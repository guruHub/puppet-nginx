# Class: nginx
#
# This module manages NGINX.
#
# Parameters:
#
# There are no default parameters for this class. All module parameters are managed
# via the nginx::params class
#
# Actions:
#
# Requires:
#  puppetlabs-stdlib - https://github.com/puppetlabs/puppetlabs-stdlib
#
#  Packaged NGINX
#    - RHEL: EPEL or custom package
#    - Debian/Ubuntu: Default Install or custom package
#    - SuSE: Default Install or custom package
#
#  stdlib
#    - puppetlabs-stdlib module >= 0.1.6
#    - plugin sync enabled to obtain the anchor type
#
# Sample Usage:
#
# The module works with sensible defaults:
#
# node default {
#   include nginx
# }
class nginx (
  $worker_processes           = $nginx::params::nx_worker_processes,
  $worker_connections         = $nginx::params::nx_worker_connections,
  $proxy_set_header           = $nginx::params::nx_proxy_set_header,
  $confd_purge                = $nginx::params::nx_confd_purge,
  $configtest_enable          = $nginx::params::nx_configtest_enable,
  $service_restart            = $nginx::params::nx_service_restart,
  $geoip_city_src             = $nginx::params::nx_geoip_city_src,
  $geoip_country_src          = $nginx::params::nx_geoip_country_src,
  $debian_package             = $nginx::params::nx_debian_package,
  $real_ip_header             = $nginx::params::nx_real_ip_header,
  $real_ips                   = $nginx::params::nx_real_ips,
  $keepalive_timeout          = $nginx::params::nx_keepalive_timeout,
  $proxy_redirect             = $nginx::params::nx_proxy_redirect,
  $client_max_body_size       = $nginx::params::nx_client_max_body_size,
  $client_body_buffer_size    = $nginx::params::nx_client_body_buffer_size,
  $proxy_buffers              = $nginx::params::nx_proxy_buffers,
  $proxy_connect_timeout      = $nginx::params::nx_proxy_connect_timeout,
  $proxy_send_timeout         = $nginx::params::nx_proxy_send_timeout,
  $proxy_read_timeout         = $nginx::params::nx_proxy_read_timeout,
  $proxy_pass_headers         = $nginx::params::nx_proxy_pass_headers,
  $proxy_buffer_size          = $nginx::params::nx_proxy_buffer_size,
  $proxy_ignore_headers       = $nginx::params::nx_proxy_ignore_headers,
  $proxy_temp_file_write_size = $nginx::params::nx_proxy_temp_file_write_size,
  $proxy_busy_buffers_size    = $nginx::params::nx_proxy_busy_buffers_size,
  $proxy_cache_use_stale      = $nginx::params::nx_proxy_cache_use_stale
) inherits nginx::params {

  include stdlib

  class { 'nginx::package':
    debian_package => $debian_package,
    notify         => Class['nginx::service'],
  }

  class { 'nginx::config':
    worker_processes 	       => $worker_processes,
    worker_connections 	       => $worker_connections,
    proxy_set_header 	       => $proxy_set_header,
    confd_purge                => $confd_purge,
    geoip_city_src             => $geoip_city_src,
    geoip_country_src          => $geoip_country_src,
    real_ip_header             => $real_ip_header,
    real_ips                   => $real_ips,
    keepalive_timeout          => $keepalive_timeout,
    proxy_redirect             => $proxy_redirect,
    client_max_body_size       => $client_max_body_size,   
    client_body_buffer_size    => $client_body_buffer_size,
    proxy_buffers              => $proxy_buffers,
    proxy_connect_timeout      => $proxy_connect_timeout,
    proxy_send_timeout         => $proxy_send_timeout,
    proxy_read_timeout         => $proxy_read_timeout,
    proxy_pass_headers         => $proxy_pass_headers,
    proxy_buffer_size          => $proxy_buffer_size,
    proxy_ignore_headers       => $proxy_ignore_headers,
    proxy_temp_file_write_size => $proxy_temp_file_write_size,
    proxy_busy_buffers_size    => $proxy_busy_buffers_size,
    proxy_cache_use_stale      => $proxy_cache_use_stale,
    require 		       => Class['nginx::package'],
    notify  		       => Class['nginx::service'],
  }

  class { 'nginx::service': 
    configtest_enable => $configtest_enable,
    service_restart => $service_restart,
  }

  # Allow the end user to establish relationships to the "main" class
  # and preserve the relationship to the implementation classes through
  # a transitive relationship to the composite class.
  anchor{ 'nginx::begin':
    before => Class['nginx::package'],
    notify => Class['nginx::service'],
  }
  anchor { 'nginx::end':
    require => Class['nginx::service'],
  }
}
