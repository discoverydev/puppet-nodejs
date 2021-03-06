# Manage node versions with nodenv.
#
# Usage:
#
#     include nodejs::nodenv
#
# Normally internal use only; will be automatically included by the `nodejs` class
# if `nodejs::provider` is set to "nodenv"

class nodejs::nodenv(
  $ensure  = $nodejs::nodenv::ensure,
  $prefix  = $nodejs::nodenv::prefix,
  $user    = "ga-mlsdiscovery",
  $plugins = {}
) {

  require nodejs

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'OiNutter/nodenv',
    user   => $user
  }

  file { "${prefix}/versions":
    ensure  => symlink,
    force   => true,
    backup  => false,
    target  => '/opt/nodes',
    require => Repository[$prefix]
  }

  if !empty($plugins) and $ensure != 'absent'  {
    create_resources('nodejs::nodenv::plugin', $plugins)
  }

}
