class kermit {
    file { "/etc/kermit/":
      ensure => directory,
    }

    file { "/etc/kermit/ssl/":
      ensure => directory,
      require => File["/etc/kermit/"],
    }

    file { "/etc/kermit/ssl/q-private.pem":
        ensure => $hostname ? {
            $recvnode => absent,
            default => present,
        },
        mode   => 644,
        owner  => root,
        group  => root,
        source => "puppet:///modules/kermit/q-private.pem",
        require => [File["/etc/kermit/ssl/"], Package["mcollective-common"]],
    }

    file { "/etc/kermit/kermit.cfg":
        ensure => present, 
        mode   => 644,
        owner  => root,
        group  => root,
        source => "puppet:///modules/kermit/kermit.cfg",
        require => File["/etc/kermit/"],
    }

    file { "/etc/kermit/amqpqueue.cfg":
        ensure => present, 
        mode   => 644,
        owner  => root,
        group  => root,
        source => "puppet:///modules/kermit/amqpqueue.cfg",
        require => File["/etc/kermit/"],
    }


    package { "kermit-gpg_key_whs": 
        ensure => installed,
        require => File["/etc/yum.repos.d/kermit.repo"], 
    }

    package { "kermit-mqsend": 
        ensure => installed,
        require => File["/etc/yum.repos.d/kermit.repo"], 
    }
}

