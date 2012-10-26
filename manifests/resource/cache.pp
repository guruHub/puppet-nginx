# define: nginx::resource::cache
#
# This definition creates a new cache_zone entry for NGINX
#
# Parameters:
#   [*ensure*]      - Enables or disables the specified cache zone (present|absent)
#
# Actions:
#
# Requires:
#
# Sample Usage (storage dir must exist):
#  nginx::resource::cache { 'domain1':
#    ensure  => present,
#    storage_dir => '/var/nginx-cache'
#  }
define nginx::resource::cache (
  $ensure      = 'present',
  $storage_dir = '/var/nginx-cache',
  $levels      = "1:2",
  $keys_zone   = "${name}:8m",
  $inactive    = "7d",
  $max_size    = "1g"
) {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { "/etc/nginx/conf.d/${name}-cache.conf":
    ensure   => $ensure ? {
      'absent' => absent,
      default  => 'file',
    },
    content  => "proxy_cache_path ${cache_path}${name} levels=${levels} keys_zone=${keys_zone} inactive=${inactive} max_size=$max_size};",
    notify   => Class['nginx::service'],
  }
}
