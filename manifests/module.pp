# == Define: proftpd::module
#
define proftpd::module ($enable = true) {
  # Load module .c file from modules.conf.
  concat::fragment { "proftp_module_${name}":
    ensure  => present,
    target  => "${::proftpd::base_dir}/modules.conf",
    content => "LoadModule mod_${name}.c \n",
    order   => '10',
  }
}
