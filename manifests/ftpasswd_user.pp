# @summary Add a user to ftpasswd
#
# @param hashed_passwd
#   A hashed password.
#
# @param uid
#   The UID of the user.
#
# @param gid
#   The GID of the user.
#
# @param homedir
#   The home directory of the user.
#
# @param shell
#   The shell of the user.
#
# @param username
#   (Namevar) The user's login name.
#
# @param gecos
#   The GECOS field with additional (optional) information about the user.
#
# @param ftpasswd_file
#   The target ftpasswd file.
define proftpd::ftpasswd_user (
  String $hashed_passwd,
  Integer $uid,
  Integer $gid,
  String $homedir = "/home/${name}",
  String $shell = '/bin/false',
  String $username = $name,
  String $gecos = $name,
  String $ftpasswd_file = $proftpd::ftpasswd_file,
) {
  concat::fragment { "10-entry-${username}":
    content => "${username}:${hashed_passwd}:${uid}:${gid}:${gecos}:${homedir}:${shell}\n",
    target  => $ftpasswd_file,
  }
}
