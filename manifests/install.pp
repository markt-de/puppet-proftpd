# @summary Install ProFTPD packages
# @api private
class proftpd::install {
  assert_private()

  if $proftpd::package_manage {
    package { $proftpd::packages:
      ensure => $proftpd::package_ensure,
    }
  }
}
