class mcollective {
    package { "mcollective-common":
        ensure  => installed,
        require => File["/etc/yum.repos.d/kermit.repo"],
    }

    package { "mcollective":
        require => Package["mcollective-common"]
        ensure  => installed,
    }

    file { "/etc/mcollective/ssl":
        require => Package["mcollective-common"]
        ensure  => 'directory',
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
    }

    file { "/etc/mcollective/ssl/clients":
        ensure  => 'directory',
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        require => File["/etc/mcollective/ssl"]
    }
    

    file { "/etc/mcollective/server.cfg":
        require => Package["mcollective-common"],
        ensure  => present,
        mode    => '0640',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mcollective/server.cfg",
    }

    file { "/etc/mcollective/client.cfg":
        require => Package["mcollective-common"],
        ensure  => $hostname ? {
            $nocnode => present,
            default  => absent,
        },
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mcollective/client.cfg",
    }

    file { "/etc/mcollective/ssl/server-private.pem":
        ensure  => present,
        mode    => '0640',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mcollective/server-private.pem",
        require => Package["mcollective-common"],
    }

    file { "/etc/mcollective/ssl/server-public.pem":
        require => Package["mcollective-common"],
        ensure  => present,
        mode    => $hostname ? {
            $nocnode => '0644',
            default  => '0640',
        },
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mcollective/server-public.pem",
    }

    file { "/etc/mcollective/ssl/clients/noc-public.pem":
        require => [ Package["mcollective-common"], 
                     File["/etc/mcollective/ssl/clients"] ],
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        source  => "puppet:///modules/mcollective/noc-public.pem",
    }

    service { "mcollective":
        ensure  => running,
        enable  => true,
        require => [ Package["mcollective"],
                     File["/etc/mcollective/server.cfg"],
                     File["/etc/mcollective/ssl/server-public.pem"],
                     File["/etc/mcollective/ssl/server-private.pem"],
                     File["/etc/mcollective/ssl/clients/noc-public.pem"] ]
    }

    package { "mcollective-plugins-agentinfo":
        ensure  => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

    package { "mcollective-plugins-nodeinfo":
        ensure  => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

    package { "mcollective-plugins-facter_facts":
        ensure  => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

    package { "mcollective-plugins-package":
        ensure  => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

    package { "mcollective-plugins-service":
        ensure  => installed,
        require => [ File["/etc/yum.repos.d/kermit.repo"],
                     Package["mcollective-common"]],
    }

}
