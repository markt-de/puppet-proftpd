#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Usage](#usage)
    * [Beginning with proftpd](#beginning-with-proftpd)
    * [Using Hiera](#using-hiera)
4. [Reference](#reference)
    * [Syntax](#syntax)
    * [Parameters](#parameters)
5. [Limitations](#limitations)
    * [OS Compatibility](#os-compatibility)
    * [Template Issues](#template-issues)
6. [Development](#development)
7. [Contributors](#contributors)

## Overview

fraenki/proftpd is a Puppet module for managing ProFTPD. It allows for very flexible configuration and is hiera-friendly.

## Requirements

* Puppet 3.x
* [puppetlabs/concat](https://github.com/puppetlabs/puppetlabs-concat)
* [puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)

## Usage

### Beginning with proftpd

This example will install packages, setup a minimal configuration and activate the service for you:

    class { 'proftpd': }

Loading additional modules is easy too:

    class { 'proftpd':
      load_modules => {
        ban => {},
        tls => {},
        sql => {},
      }
    }

It is simple to add new options or overwrite the defaults in the configuration root or any (sub) section:

    class { 'proftpd':
      options => {
        'ROOT'  => {
          'ServerName'   => 'FTP server',
          'MaxInstances' => '10',
        },
        'IfModule mod_vroot.c' => {
          'VRootEngine' => 'on',
        },
      },
    }

NOTE: You don't need to take care for section brackets or closing tags. The module will add this automatically.

Enabling anonymous login and customizing it's default options works the same way:

    class { 'proftpd':
      anonymous_enable => true,
      options          => {
        'Anonymous ~ftp'        => {
          'Directory uploads/*' => {
            'Limit STOR'        => {
              'AllowAll'        => true,
              'DenyAll'         => false,
            },
          },
        },
      },

You may opt to disable the default configuration and do everything from scratch:

    class { 'proftpd':
      default_config => false,
      options => {...}
    }

(Here the options hash must contain all options required to run ProFTPD.)

### Using Hiera

You're encouraged to define your configuration using Hiera, especially if you plan to disable the default configuration:

    proftpd::default_config: false
    proftpd::load_modules:
      ban: {}
      sql: {}
      tls: {}

    proftpd::options:
      ROOT:
        ServerType: 'standalone'
        DefaultServer: 'on'
        ScoreboardFile: '/var/run/proftpd.scoreboard'
        DelayTable: '/var/run/proftpd.delay'
        ControlsSocket: '/var/run/proftpd.socket'
        User: 'www'
        Group: 'www'
        Umask: '006'
        UseReverseDNS: 'off'
        DefaultRoot: '~ !'
        DefaultChdir: '/var/ftp'
        ServerName: '%{::fqdn}'
        Port: '21'
        PassivePorts: '49152 65534'
        TransferLog: 'NONE'
        LogFormat:
          - 'default "%h %l %u %t \"%r\" %s %b"'
          - 'auth "%t %v [%P] %h \"%r\" %s"'
          - 'access "%h %l %u %t \"%r\" %s %b"'
        ExtendedLog:
          - '/var/log/proftpd/access.log INFO,DIRS,MISC,READ,WRITE access'
          - '/var/log/proftpd/auth.log AUTH auth'
        MaxClients: '20 "Connection limit reached (%m)."'
        MaxInstances: '20'
        MaxClientsPerHost: '15 "Connection limit reached (%m)."'
        MaxClientsPerUser: '10 "Connection limit reached (%m)."'
        TLSEngine: 'on'
        TLSProtocol: 'SSLv23'
        TLSRequired: 'off'
        TLSOptions: 'NoCertRequest'
        TLSCipherSuite: 'ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP'
        TLSVerifyClient: 'off'
        TLSRSACertificateFile: '/etc/ssl/%{::fqdn}.crt'
        TLSRSACertificateKeyFile: '/etc/ssl/%{::fqdn}.key'
        TLSLog: '/var/log/proftpd/tls.log'
      Global:
        RequireValidShell: 'off'
        UseFtpUsers: 'on'
        AllowRetrieveRestart: 'on'
        AllowStoreRestart: 'on'
        AllowOverwrite: 'yes'
        AccessGrantMsg: '"Login OK"'
        IdentLookups: 'off'
        ServerIdent: 'on "FTP Service"'
        AllowForeignAddress: 'on'
        DirFakeUser: 'on www'
        DirFakeGroup: 'on www'
        PathDenyFilter: '"(\.ftpaccess)$"'
        ListOptions: '"-a"'
        MaxLoginAttempts: '2'
        AuthUserFile: '/etc/proftpd/proftpd.passwd'
        AuthGroupFile: '/etc/proftpd/proftpd.group'
        TimeoutLogin: '1800'
        TimeoutIdle: '1800'
        TimeoutStalled: '1800'
        TimeoutNoTransfer: '1800'
      'Directory /':
        AllowOverwrite: 'on'

## Reference

### Syntax

You may want to use the `$options` parameter to overwrite default configuration options or build a ProFTPD configuration from scratch. There are few things you need to know:

* `sections`: ProFTPD's configuration uses a number of &lt;sections&gt;. You create a new section by specifying a hash, the module's erb template will do the rest for you. This works for special cases like &lt;IfDefine X&gt; too.
* `ROOT`: To add items to the root of the ProFTPD configuration, use this namespace.
* `false`: Setting a value to 'false' will remove the item from the configuration.
* `multiple values`: If you want to specify multiple values for the same configuration item (i.e. `LogFormat` or `ExtendedLog`), you need to specify these values as an array.

### Parameters

* `anonymous_options`: An optional hash containing the default options to configure ProFTPD for anonymous FTP access. Use this to overwrite these defaults.
* `anonymous_enable`: Set to 'true' to enable loading of the `$anonymous_options` hash.
* `load_modules`: A hash of optional ProFTPD modules to load.
* `options`: Specify a hash containing options to either overwrite the default options or configure ProFTPD from scratch. Will be merged with `$default_options` hash (as long as `$default_config` is not set to 'false').
* `default_options`: A hash containing a set of working default options for ProFTPD. This should make it easy to get a running service and to overwrite a few settings.
* `config_template`: Specify which erb template to use.
* `default_config`: Set to 'false' to disable loading of the default configuration. Defaults to 'true'.
* `manage_config_file`: Set to 'false' to disable managing of the ProFTPD configuration file(s).
* `packages`: An array of packages which should be installed.
* `package_ensure`: Overwrite the package 'ensure' parameter.
* `package_manage`: Set to 'false' to disable package management. Defaults to 'true'.
* `service_name`: The name of the ProFTPD service.
* `service_manage`: Set to 'false' to disable service management. Defaults to 'true'.
* `service_enable`: Set to 'false' to disable the ProFTPD system service. Defaults to 'true'.
* `service_ensure`: Overwrite the service 'ensure' parameter.
* `prefix`: Prefix to be added to all paths. Only required on certain operating systems or special installations.
* `prefix_bin`: Path to the ProFTPD binary.
* `config`: Path to the ProFTPD configuration file.
* `base_dir`: Directory for additional configuration files.
* `log_dir`: Directory for log files.
* `run_dir`: Directory for runtime files (except PIDfile).
* `pidfile`: Path and name of the PIDfile for the ProFTPD service.
* `scoreboardfile`: Path and name of the ScoreboardFile for the ProFTPD service.
* `user`: Set the user under which the server will run.
* `group`: Set the group under which the server will run.

## Limitations

### OS Compatibility

This module was tested on FreeBSD, CentOS and Debian. Please open a new issue if your operating system is not supported yet, and provide information about problems or missing features.

### Template Issues

The `proftpd.conf.erb` template... sucks. It suffers from code repetition. Furthermore it is limited to only four nested configuration sections (which should still be enough, even for rather complex configurations). If you come up with a better idea please let me know.

## Development

Please use the github issues functionality to report any bugs or requests for new features. Feel free to fork and submit pull requests for potential contributions.

## Contributors

This module is heavily inspired by and in part based on the following modules:

* [arioch/puppet-proftpd](https://github.com/arioch/puppet-proftpd)
* [takumin/puppet-proftpd](https://github.com/takumin/puppet-proftpd)
* [cegeka/puppet-proftpd](https://github.com/cegeka/puppet-proftpd)

See the `LICENSE` file for further information.
