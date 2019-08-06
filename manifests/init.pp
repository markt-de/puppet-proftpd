# == Class proftpd
#
class proftpd (
  # module parameters
  String[1]                      $config_template      = $proftpd::params::config_template,
  Boolean                        $default_config       = $proftpd::params::default_config,
  Boolean                        $manage_config_file   = $proftpd::params::manage_config_file,
  Boolean                        $manage_ftpasswd_file = $proftpd::params::manage_ftpasswd_file,
  String                         $package_ensure       = $proftpd::params::package_ensure,
  Boolean                        $package_manage       = $proftpd::params::package_manage,
  Boolean                        $service_manage       = $proftpd::params::service_manage,
  Boolean                        $service_enable       = $proftpd::params::service_enable,
  String                         $service_ensure       = $proftpd::params::service_ensure,
  # os-specific parameters
  Optional[Stdlib::Absolutepath] $prefix               = $proftpd::params::prefix,
  Stdlib::Filemode               $config_mode          = $proftpd::params::config_mode,
  Stdlib::Absolutepath           $prefix_bin           = $proftpd::params::prefix_bin,
  Stdlib::Absolutepath           $config               = $proftpd::params::config,
  Stdlib::Absolutepath           $base_dir             = $proftpd::params::base_dir,
  Stdlib::Absolutepath           $log_dir              = $proftpd::params::log_dir,
  Stdlib::Absolutepath           $run_dir              = $proftpd::params::run_dir,
  Array[String[1]]               $packages             = $proftpd::params::packages,
  String[1]                      $service_name         = $proftpd::params::service_name,
  String[1]                      $user                 = $proftpd::params::user,
  String[1]                      $group                = $proftpd::params::group,
  Stdlib::Absolutepath           $pidfile              = $proftpd::params::pidfile,
  Stdlib::Absolutepath           $scoreboardfile       = $proftpd::params::scoreboardfile,
  Stdlib::Absolutepath           $ftpasswd_file        = $proftpd::params::ftpasswd_file,
  # proftpd configuration
  Hash                           $anonymous_options    = $proftpd::params::anonymous_options,
  Boolean                        $anonymous_enable     = $proftpd::params::anonymous_enable,
  Hash                           $default_options      = $proftpd::params::default_options,
  Hash                           $load_modules         = $proftpd::params::load_modules,
  Hash                           $options              = $proftpd::params::options,
  Optional[Stdlib::Filesource]   $authuserfile_source  = $proftpd::params::authuserfile_source,
  Optional[Stdlib::Filesource]   $authgroupfile_source = $proftpd::params::authgroupfile_source,
) inherits proftpd::params {
  # resource relationships
  class { 'proftpd::install': }
  -> class { 'proftpd::config': }
  ~> class { 'proftpd::service': }

  if $load_modules {
    create_resources(proftpd::module, $load_modules, {})
  }
}
