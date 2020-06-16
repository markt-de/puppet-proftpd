# @summary Manage the ProFTPD service
# @api private
class proftpd::service {
  assert_private()

  if $proftpd::service_manage {
    service { $proftpd::service_name:
      ensure  => $proftpd::service_ensure,
      enable  => $proftpd::service_enable,
      require => Class['proftpd::config'],
    }
  }
}
