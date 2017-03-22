# == Class proftpd::config
#
class proftpd::config {

  # Should we manage the configuration at all?
  if ( $::proftpd::manage_config_file == true ) {

    $modules_config = "${::proftpd::base_dir}/modules.conf"

    # check if anonymous access should be enabled
    if ( $::proftpd::anonymous_enable == true ) {
      $real_defaults = deep_merge($::proftpd::default_options,
                                  $::proftpd::anonymous_options)

    }
    # do not include options for anonymous access
    else { $real_defaults = $::proftpd::default_options }

    # check if defaults should be included
    # re-hash due to hiera 1.x known limitation
    $hash_options = hiera_hash('proftpd::options',$::proftpd::options)
    if ( $::proftpd::default_config == true ) {
      $real_options = deep_merge($real_defaults, $hash_options)
    }
    # do not include defaults
    else { $real_options = $hash_options }

    # required variables
    $base_dir     = $::proftpd::base_dir
    $load_modules = $::proftpd::load_modules

    # create AuthUserFile/AuthGroupFile to allow the configtest to succeed
    if $real_options['ROOT'] and $real_options['ROOT']['AuthUserFile'] {
      $authuser_require = File[$real_options['ROOT']['AuthUserFile']]
      if !defined(File[$real_options['ROOT']['AuthUserFile']]) {
        file { $real_options['ROOT']['AuthUserFile']:
          ensure => present,
          source => $::proftpd::authuserfile_source,
          owner  => $::proftpd::user,
          group  => $::proftpd::group,
          mode   => '0600',
          before => File[$::proftpd::config],
        }
      }
    } elsif $real_options['Global'] and
        $real_options['Global']['AuthUserFile'] {
      $authuser_require = File[$real_options['Global']['AuthUserFile']]
      if !defined(File[$real_options['Global']['AuthUserFile']]) {
        file { $real_options['Global']['AuthUserFile']:
          ensure => present,
          source => $::proftpd::authuserfile_source,
          owner  => $::proftpd::user,
          group  => $::proftpd::group,
          mode   => '0600',
          before => File[$::proftpd::config],
        }
      }
    }
    if $real_options['ROOT'] and $real_options['ROOT']['AuthGroupFile'] {
      $authgroup_require = File[$real_options['ROOT']['AuthGroupFile']]
      if !defined(File[$real_options['ROOT']['AuthGroupFile']]) {
        file { $real_options['ROOT']['AuthGroupFile']:
          ensure => present,
          source => $::proftpd::authgroupfile_source,
          owner  => $::proftpd::user,
          group  => $::proftpd::group,
          mode   => '0600',
          before => File[$::proftpd::config],
        }
      }
    } elsif $real_options['Global'] and
        $real_options['Global']['AuthGroupFile'] {
      $authgroup_require = File[$real_options['Global']['AuthGroupFile']]
      if !defined(File[$real_options['Global']['AuthGroupFile']]) {
        file { $real_options['Global']['AuthGroupFile']:
          ensure => present,
          source => $::proftpd::authgroupfile_source,
          owner  => $::proftpd::user,
          group  => $::proftpd::group,
          mode   => '0600',
          before => File[$::proftpd::config],
        }
      }
    }
    if $authuser_require and $authgroup_require {
      $config_require = [Concat[$modules_config], $authuser_require,
                        $authgroup_require]
    } elsif $authuser_require {
      $config_require = [Concat[$modules_config], $authuser_require]
    } elsif $authgroup_require {
      $config_require = [Concat[$modules_config], $authgroup_require]
    } else { $config_require = Concat[$modules_config] }

    File {
      ensure  => present,
      require => Class['::proftpd::install'],
    }

    file {
      $::proftpd::base_dir:
        ensure => directory,
        owner  => $::proftpd::config_user,
        group  => $::proftpd::config_group;

      $::proftpd::log_dir:
        ensure => directory,
        owner  => $::proftpd::config_user,
        group  => $::proftpd::config_group;

      $::proftpd::run_dir:
        ensure => directory,
        owner  => $::proftpd::config_user,
        group  => $::proftpd::config_group;

      $::proftpd::config:
        ensure       => file,
        mode         => $::proftpd::config_mode,
        content      => template($::proftpd::config_template),
        validate_cmd => "${::proftpd::prefix_bin}/proftpd -t -c %",
        owner        => $::proftpd::config_user,
        group        => $::proftpd::config_group,
        require      => $config_require,
        notify       => Class[::proftpd::service];
    }

    concat { $modules_config:
      owner  => $::proftpd::config_user,
      group  => $::proftpd::config_group,
      # modules may be required for validate_cmd to succeed
      before => File[$::proftpd::config],
      notify => Class[::proftpd::service],
    }

    concat::fragment { 'proftp_modules_header':
      target  => "${::proftpd::base_dir}/modules.conf",
      content => "# File is managed by Puppet\n",
      order   => '01',
    }

  }

}
