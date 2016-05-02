# == Class proftpd::config
#
class proftpd::config {

  # Should we manage the configuration at all?
  if ( $::proftpd::manage_config_file == true ) {

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
    # XXX: may be found in server config, <VirtualHost>, <Global>
    if $real_options['ROOT']['AuthUserFile'] {
      if !defined(File["${real_options['ROOT']['AuthUserFile']}"]) {
        file { "${real_options['ROOT']['AuthUserFile']}":
          ensure => present,
          mode   => '0600',
        }
      }
    }
    if $real_options['ROOT']['AuthGroupFile'] {
      if !defined(File["${real_options['ROOT']['AuthGroupFile']}"]) {
        file { "${real_options['ROOT']['AuthGroupFile']}":
          ensure => present,
          mode   => '0600',
        }
      }
    }

    File {
      ensure  => present,
      require => Class['::proftpd::install'],
      notify  => Service[$::proftpd::service_name],
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
        group        => $::proftpd::config_group
        require      => File["${::proftpd::base_dir}/modules.conf"];
    }

    concat { "${::proftpd::base_dir}/modules.conf":
      owner  => $::proftpd::config_user,
      group  => $::proftpd::config_group,
      # modules may be required for validate_cmd to succeed
      before => File[$::proftpd::config],
    }

    concat::fragment { 'proftp_modules_header':
      ensure  => present,
      target  => "${::proftpd::base_dir}/modules.conf",
      content => "# File is managed by Puppet\n",
      order   => '01',
    }

  }

}
