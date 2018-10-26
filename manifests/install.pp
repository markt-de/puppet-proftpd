# == Class proftpd::install
#
class proftpd::install {
  if $proftpd::package_manage {
    package { $proftpd::packages:
      ensure => $proftpd::package_ensure,
    }
  }
}
