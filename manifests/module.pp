# == Define: proftpd::module
#
define proftpd::module (
  $enable = true,
  $order  = '10',
) {
  # Load module .c file from modules.conf.
  concat::fragment { "proftp_module_${name}":
    target  => "${proftpd::base_dir}/modules.conf",
    content => "LoadModule mod_${name}.c \n",
    order   => $order,
  }
}
