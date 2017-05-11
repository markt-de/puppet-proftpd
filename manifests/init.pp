# == Class proftpd
#
class proftpd (
  # module parameters
  $config_template      = $::proftpd::params::config_template,
  $default_config       = $::proftpd::params::default_config,
  $manage_config_file   = $::proftpd::params::manage_config_file,
  $manage_ftpasswd_file = $::proftpd::params::manage_ftpasswd_file,
  $package_ensure       = $::proftpd::params::package_ensure,
  $package_manage       = $::proftpd::params::package_manage,
  $service_manage       = $::proftpd::params::service_manage,
  $service_enable       = $::proftpd::params::service_enable,
  $service_ensure       = $::proftpd::params::service_ensure,
  # os-specific parameters
  $prefix               = $::proftpd::params::prefix,
  $prefix_bin           = $::proftpd::params::prefix_bin,
  $config               = $::proftpd::params::config,
  $base_dir             = $::proftpd::params::base_dir,
  $log_dir              = $::proftpd::params::log_dir,
  $run_dir              = $::proftpd::params::run_dir,
  $packages             = $::proftpd::params::packages,
  $service_name         = $::proftpd::params::service_name,
  $user                 = $::proftpd::params::user,
  $group                = $::proftpd::params::group,
  $pidfile              = $::proftpd::params::pidfile,
  $scoreboardfile       = $::proftpd::params::scoreboardfile,
  $ftpasswd_file        = $::proftpd::params::ftpasswd_file,
  # proftpd configuration
  $anonymous_options    = $::proftpd::params::anonymous_options,
  $anonymous_enable     = $::proftpd::params::anonymous_enable,
  $default_options      = $::proftpd::params::default_options,
  $load_modules         = $::proftpd::params::load_modules,
  $options              = $::proftpd::params::options,
  $authuserfile_source  = $::proftpd::params::authuserfile_source,
  $authgroupfile_source = $::proftpd::params::authgroupfile_source,
) inherits proftpd::params {

  include stdlib

  # simple validation
  validate_bool($anonymous_enable)
  validate_hash($anonymous_options)
  validate_string($config_template)
  validate_bool($default_config)
  validate_hash($default_options)
  validate_hash($load_modules)
  validate_bool($manage_config_file)
  validate_hash($options)
  validate_array($packages)
  validate_bool($package_manage)
  validate_string($package_ensure)
  validate_bool($service_manage)
  validate_string($service_name)
  validate_bool($service_enable)
  validate_string($service_ensure)

  # resource relationships
  class { '::proftpd::install': } ->
  class { '::proftpd::config': } ~>
  class { '::proftpd::service': }

  if $::proftpd::load_modules {
    create_resources(proftpd::module, $load_modules, {})
  }
}
