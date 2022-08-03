# @summary Load a ProFTPD module
#
# @param enable
#    Whether the module should be enabled.
#
# @param order
#    Specify the order in which modules should be loaded.
#
# @api private
define proftpd::module (
  Boolean $enable = true,
  Variant[Integer,String] $order = '10',
) {
  assert_private()

  # Load module .c file from modules.conf.
  concat::fragment { "proftp_module_${name}":
    target  => "${proftpd::base_dir}/modules.conf",
    content => "LoadModule mod_${name}.c \n",
    order   => $order,
  }
}
