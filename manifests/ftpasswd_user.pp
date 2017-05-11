define proftpd::ftpasswd_user(
    $hashed_passwd,
    $uid,
    $gid,
    $homedir = "/home/${name}",
    $shell = '/bin/false',
    $username = $name,
    $gecos = $name,
    $ftpasswd_file = $::proftpd::ftpasswd_file,
) {
    concat::fragment { "10-entry-${username}":
      content => "${username}:${hashed_passwd}:${uid}:${gid}:${gecos}:${homedir}:${shell}\n",
      target  => $ftpasswd_file,
    }
}
