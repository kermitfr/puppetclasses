class mcollective {
    package { "mcollective-common":
        ensure => installed
    }

    package { "mcollective":
        ensure => installed,
        require => Package["mcollective-common"]
    }

    file { "/etc/mcollective/server.cfg":
        ensure => present,
        mode   => 640,
        owner  => root,
        group  => root,
        source => "puppet:///modules/mcollective/server.cfg",
        require => Package["mcollective-common"],
    }

    file { "/etc/mcollective/client.cfg":
        ensure => $hostname ? {
            $nocnode => present,
            default => absent,
        },
        mode   => 644,
        owner  => root,
        group  => root,
        source => "puppet:///modules/mcollective/client.cfg",
        require => Package["mcollective-common"],
    }

    file { "/etc/mcollective/ssl/server-private.pem":
        ensure => present,
        mode   => 640,
        owner  => root,
        group  => root,
        source => "puppet:///modules/mcollective/server-private.pem",
        require => Package["mcollective-common"],
    }

    file { "/etc/mcollective/ssl/server-public.pem":
        ensure => present,
        mode   => $hostname ? {
            $nocnode => 644,
            default  => 640,
        },
        owner  => root,
        group  => root,
        source => "puppet:///modules/mcollective/server-public.pem",
        require => Package["mcollective-common"],
    }

    file { "/etc/mcollective/ssl/clients/noc-public.pem":
        ensure => present,
        mode   => 644,
        owner  => root,
        group  => root,
        source => "puppet:///modules/mcollective/noc-public.pem",
        require => Package["mcollective-common"],
    }

    service { "mcollective":
        ensure => running,
        enable => true,
        require => [ Package["mcollective"],
                     File["/etc/mcollective/server.cfg"],
                     File["/etc/mcollective/ssl/server-public.pem"],
                     File["/etc/mcollective/ssl/server-private.pem"],
                     File["/etc/mcollective/ssl/clients/noc-public.pem"] ]
    }

    package { "mcollective-plugins-agentinfo":
        ensure => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

    package { "mcollective-plugins-nodeinfo":
        ensure => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

    package { "mcollective-plugins-facter_facts":
        ensure => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

    package { "mcollective-plugins-package":
        ensure => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

    package { "mcollective-plugins-service":
        ensure => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

}
