define network::route (
  $destination = 'default',
  $via,
) {
  # This file is only executed at boot time
  file { "/etc/network/if-up.d/99-${title}":
    ensure  => file,
    content => template("${module_name}/route/if-up.erb"),
    owner   => '0',
    group   => '0',
    mode    => '0750',
  }

  exec { "[${title}] Set route to ${destination} via ${via}":
    provider    => shell,
    command     => "/etc/network/if-up.d/99-${title}",
    refreshonly => true,
    path        => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    user        => 'root',
    subscribe   => File["/etc/network/if-up.d/99-${title}"],
  }
}
