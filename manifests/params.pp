# == Class proftpd::params
#
# This class is meant to be called from proftpd.
# It sets variables according to platform.
#
class proftpd::params {
  # global module configuration
  $anonymous_enable   = false
  $config_template    = "${module_name}/proftpd.conf.erb"
  $default_config     = true
  $load_modules       = {}
  $manage_config_file = true
  $options            = {}
  $package_ensure     = 'present'
  $package_manage     = true
  $service_manage     = true
  $service_enable     = true
  $service_ensure     = 'running'

  case $::osfamily {
    'Debian', 'RedHat', 'Amazon': {
      $prefix         = undef
      $prefix_bin     = '/usr/sbin'
      $config         = '/etc/proftpd.conf'
      $config_user    = 'root'
      $config_group   = 'root'
      $config_mode    = '0644'
      $base_dir       = '/etc/proftpd'
      $log_dir        = '/var/log/proftpd'
      $run_dir        = '/var/run/proftpd'
      $pidfile        = '/var/run/proftpd.pid'
      $scoreboardfile = '/var/run/proftpd.scoreboard'
      $packages       = [ 'proftpd' ]
      $service_name   = 'proftpd'
      $user           = 'nobody'
      $group          = 'nobody'
    }
    'FreeBSD': {
      $prefix         = '/usr/local'
      $prefix_bin     = "${prefix}/sbin"
      $config         = "${prefix}/etc/proftpd.conf"
      $config_user    = 'root'
      $config_group   = 'wheel'
      $config_mode    = '0644'
      $base_dir       = "${prefix}/etc/proftpd"
      $log_dir        = '/var/log/proftpd'
      $run_dir        = '/var/run/proftpd'
      $pidfile        = '/var/run/proftpd.pid'
      $scoreboardfile = '/var/run/proftpd.scoreboard'
      $packages       = [ 'ftp/proftpd' ]
      $service_name   = 'proftpd'
      $user           = 'nobody'
      $group          = 'nogroup'
    }
    default: {
      fail("module ${module_name} does not support ${::operatingsystem}")
    }
  }

  # minimal default config, should work on most systems
  $default_options = {
    'ROOT'                 => {
      'ServerName'         => "ProFTPD server ${::fqdn}",
      'ServerIdent'        => 'on "FTP Server ready."',
      'ServerAdmin'        => "root@${::domain}",
      'DefaultServer'      => 'on',
      'DefaultRoot'        => '~ !adm',
      'AuthPAMConfig'      => 'proftpd',
      'AuthOrder'          => 'mod_auth_pam.c* mod_auth_unix.c',
      'UseReverseDNS'      => 'off',
      'User'               => $user,
      'Group'              => $group,
      'MaxInstances'       => '20',
      'UseSendfile'        => 'off',
      'LogFormat'          => 'default  "%h %l %u %t \"%r\" %s %b"',
      'LogFormat'          => 'auth     "%v [%P] %h %t \"%r\" %s"',
      'TransferLog'        => "${log_dir}/xferlog",
      'SystemLog'          => "${log_dir}/proftpd.log",
      'ModuleControlsACLs' => 'insmod,rmmod allow user root',
      'ModuleControlsACLs' => 'lsmod allow user *',
      'ControlsEngine'     => 'on',
      'ControlsACLs'       => 'all allow user root',
      'ControlsSocketACL'  => 'allow user *',
      'ControlsLog'        => "${log_dir}/controls.log",
    },
    'IfModule mod_ctrls_admin.c' => {
      'AdminControlsEngine'      => 'on',
      'AdminControlsACLs'        => 'all allow user root',
    },
    'IfModule mod_vroot.c'       => {
      'VRootEngine'              => 'on',
    },
    'IfModule mod_tls_shmcache.c' => {
      'TLSSessionCache'           => "shm:/file=${run_dir}/sesscache",
    },
    'Global'           => {
      'Umask'          => '022',
      'AllowOverwrite' => 'yes',
      'Limit ALL SITE_CHMOD' => {
        'AllowAll' => true,
      },
    },
  }

  # config to enable anonymous access
  $anonymous_options = {
    'Anonymous ~ftp'       => {
      'User'               => 'ftp',
      'Group'              => 'ftp',
      'AccessGrantMsg'     => '"Anonymous login ok, restrictions apply."',
      'UserAlias'          => 'anonymous ftp',
      'MaxClients'         => '10 "Sorry, max %m users -- try again later"',
      'DisplayLogin'       => '/welcome.msg',
      'DisplayChdir'       => '.message',
      'DisplayReadme'      => 'README*',
      'DirFakeUser'        => 'on ftp',
      'DirFakeGroup'       => 'on ftp',
      'Limit WRITE SITE_CHMOD' => {
        'DenyAll'              => true,
      },
      'Directory uploads/*' => {
        'AllowOverwrite'    => 'no',
        'Limit READ'        => {
          'DenyAll'         => true,
        },
        'Limit STOR'        => {
          'AllowAll'        => true,
        },
      },
      'WtmpLog'            => 'off',
      'ExtendedLog'        => "${log_dir}/access.log WRITE,READ default",
      'ExtendedLog'        => "${log_dir}/auth.log AUTH auth",
    },
  }

}
