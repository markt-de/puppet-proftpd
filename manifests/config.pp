# @summary Setup ProFTPD configuration
# @api private
class proftpd::config {
  assert_private()

  # Should we manage the configuration at all?
  if $proftpd::manage_config_file {
    $modules_config = "${proftpd::base_dir}/modules.conf"

    # check if anonymous access should be enabled
    if $proftpd::anonymous_enable {
      $real_defaults = deep_merge($proftpd::default_options,
      $proftpd::anonymous_options)
    }
    # do not include options for anonymous access
    else { $real_defaults = $proftpd::default_options }

    # check if defaults should be included
    if $proftpd::default_config {
      $real_options = deep_merge($real_defaults, $proftpd::options)
    }
    # do not include defaults
    else { $real_options = $proftpd::options }

    # required variables
    $base_dir     = $proftpd::base_dir
    $load_modules = $proftpd::load_modules

    # create AuthUserFile/AuthGroupFile to allow the configtest to succeed
    if $real_options['ROOT'] and $real_options['ROOT']['AuthUserFile'] {
      $authuser_require = File[$real_options['ROOT']['AuthUserFile']]
      if !defined(File[$real_options['ROOT']['AuthUserFile']]) {
        file { $real_options['ROOT']['AuthUserFile']:
          source => $proftpd::authuserfile_source,
          owner  => $proftpd::user,
          group  => $proftpd::group,
          mode   => '0600',
          before => File[$proftpd::config],
        }
      }
    } elsif $real_options['Global'] and
    $real_options['Global']['AuthUserFile'] {
      # get the first argument and only use that for creating the file (don't use spaces in filename)
      $authuserfile = split($real_options['Global']['AuthUserFile'], ' ')[0]

      if !$proftpd::manage_ftpasswd_file {
        $authuser_require = File[$authuserfile]
        if !defined(File[$authuserfile]) {
          file { $authuserfile:
            source => $proftpd::authuserfile_source,
            owner  => $proftpd::user,
            group  => $proftpd::group,
            mode   => '0600',
            before => File[$proftpd::config],
          }
        }
      } else {
        $authuser_require = false
      }
    } else {
      $authuser_require = false
    }
    if $real_options['ROOT'] and $real_options['ROOT']['AuthGroupFile'] {
      # get the first argument and only use that for creating the file (don't use spaces in filename)
      $authgroupfile = split($real_options['ROOT']['AuthGroupFile'], ' ')[0]

      $authgroup_require = File[$authgroupfile]
      if !defined(File[$authgroupfile]) {
        file { $authgroupfile:
          source => $proftpd::authgroupfile_source,
          owner  => $proftpd::user,
          group  => $proftpd::group,
          mode   => '0600',
          before => File[$proftpd::config],
        }
      }
    } elsif $real_options['Global'] and
    $real_options['Global']['AuthGroupFile'] {
      $authgroup_require = File[$real_options['Global']['AuthGroupFile']]
      if !defined(File[$real_options['Global']['AuthGroupFile']]) {
        file { $real_options['Global']['AuthGroupFile']:
          source => $proftpd::authgroupfile_source,
          owner  => $proftpd::user,
          group  => $proftpd::group,
          mode   => '0600',
          before => File[$proftpd::config],
        }
      }
    } else {
      $authgroup_require = false
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
      require => Class['proftpd::install'],
    }

    file {
      $proftpd::base_dir:
        ensure => directory,
        owner  => $proftpd::config_user,
        group  => $proftpd::config_group;

      $proftpd::log_dir:
        ensure => directory,
        owner  => $proftpd::config_user,
        group  => $proftpd::config_group;

      $proftpd::run_dir:
        ensure => directory,
        owner  => $proftpd::config_user,
        group  => $proftpd::config_group;

      $proftpd::config:
        ensure       => file,
        mode         => $proftpd::config_mode,
        content      => template($proftpd::config_template),
        validate_cmd => "${proftpd::prefix_bin}/proftpd -t -c %",
        owner        => $proftpd::config_user,
        group        => $proftpd::config_group,
        require      => $config_require,
        notify       => Class[proftpd::service];
    }

    concat { $modules_config:
      warn   => true,
      owner  => $proftpd::config_user,
      group  => $proftpd::config_group,
      # modules may be required for validate_cmd to succeed
      before => File[$proftpd::config],
      notify => Class[proftpd::service],
    }
  }
  if $proftpd::manage_ftpasswd_file {
    concat { $proftpd::ftpasswd_file:
      warn   => true,
      mode   => '0600',
      owner  => $proftpd::user,
      group  => $proftpd::group,
      before => File[$proftpd::config],
      notify => Class[proftpd::service],
    }
  }
}
