# Class: nginx::config
#
# This module manages NGINX bootstrap and configuration
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
class nginx::config(
  $worker_processes        = $nginx::params::nx_worker_processes,
  $worker_connections      = $nginx::params::nx_worker_connections,
  $proxy_set_header        = $nginx::params::nx_proxy_set_header,
  $confd_purge             = $nginx::params::nx_confd_purge,
  $geoip_city_src          = $nginx::params::nx_geoip_city_src,
  $geoip_country_src       = $nginx::params::nx_geoip_country_src,
  $real_ip_header          = $nginx::params::nx_real_ip_header,
  $real_ips                = $nginx::params::nx_real_ips,
  $proxy_redirect          = $nginx::params::nx_proxy_redirect,
  $client_max_body_size    = $nginx::params::nx_client_max_body_size,
  $client_body_buffer_size = $nginx::params::nx_client_body_buffer_size,
  $proxy_buffers           = $nginx::params::nx_proxy_buffers,
  $proxy_connect_timeout   = $nginx::params::nx_proxy_connect_timeout,
  $proxy_send_timeout      = $nginx::params::nx_proxy_send_timeout,
  $proxy_read_timeout      = $nginx::params::nx_proxy_read_timeout,
  $proxy_pass_headers      = $nginx::params::nx_proxy_pass_headers

) inherits nginx::params {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { "${nginx::params::nx_conf_dir}":
    ensure => directory,
  }

  file { "${nginx::params::nx_conf_dir}/conf.d":
    ensure => directory,
  }
  if $confd_purge == true {
    File["${nginx::params::nx_conf_dir}/conf.d"] {
      purge   => true,
      recurse => true
    }
  }

  if $geoip_city_src != false {
    $geoip_dat_destination = "${nginx::params::nx_conf_dir}/geoip_city.dat"
    $geoip_dat_source      = $geoip_city_src
    $geoip_dat_type        = 'geoip_city'
  } elsif $geoip_country_src != false {
    $geoip_dat_destination = "${nginx::params::nx_conf_dir}/geoip_country.dat"
    $geoip_dat_source      = $geoip_country_src
    $geoip_dat_type        = 'geoip_country'
  }
  if $geoip_dat_source {
    file { $geoip_dat_destination :
      ensure => file,
      source => $geoip_dat_source
    }
  }

  file { "${nginx::config::nx_run_dir}":
    ensure => directory,
  }

  file { "${nginx::config::nx_client_body_temp_path}":
    ensure => directory,
    owner  => $nginx::params::nx_daemon_user,
  }

  file {"${nginx::config::nx_proxy_temp_path}":
    ensure => directory,
    owner  => $nginx::params::nx_daemon_user,
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
  }

  file { "${nginx::params::nx_conf_dir}/nginx.conf":
    ensure  => file,
    content => template('nginx/conf.d/nginx.conf.erb'),
  }

  file { "${nginx::params::nx_conf_dir}/conf.d/proxy.conf":
    ensure  => file,
    content => template('nginx/conf.d/proxy.conf.erb'),
  }

  file { "${nginx::config::nx_temp_dir}/nginx.d":
    ensure  => directory,
    purge   => true,
    recurse => true,
  }

}
