# @summary Install ProFTPD packages
# @api private
class proftpd::install {
  assert_private()

  if $facts['os']['family'] == 'RedHat' {
    Yumrepo <| |> -> Package <| |>
  }

  if $proftpd::package_manage {
    package { $proftpd::packages:
      ensure => $proftpd::package_ensure,
    }
  }
}
