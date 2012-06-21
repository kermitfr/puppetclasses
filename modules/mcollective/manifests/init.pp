class mcollective {
    
    include yum
   
    package { 'mcollective-common':
        ensure   => present,
        require  => Yumrepo['kermit-custom', 'kermit-thirdpart'],
    }

    package { 'mcollective':
        ensure   => installed,
        require  => Package['mcollective-common'],
    }

    file { '/etc/mcollective/ssl':
        ensure  => 'directory',
        mode    => 0755,
        owner   => root,
        group   => root,
        require => Package['mcollective-common'],
    }

    file { '/etc/mcollective/ssl/clients':
        ensure  => 'directory',
        mode    => 0755,
        owner   => root,
        group   => root,
        require => File['/etc/mcollective/ssl'],
    }

    file{"/etc/mcollective/facts.yaml":
        owner    => root,
        group    => root,
        mode     => 400,
        loglevel => debug,  # this is needed to avoid it being logged
                            # and reported on every run
        # avoid including highly-dynamic facts
        # as they will cause unnecessary template writes
        content  => inline_template("<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime|timestamp|memory|free|swap)/ }.to_yaml %>")
    }

    file { '/etc/mcollective/server.cfg':
        ensure       => present,
        mode         => 0640,
        owner        => root,
        group        => root,
        source       => 'puppet:///mcollective/server.cfg',
        require      => Package['mcollective-common'],
    }

    file { '/etc/mcollective/client.cfg':
        ensure => $hostname ? {
            $nocnode => present,
            default  => absent,
        },
        mode    => 0644,
        owner   => root,
        group   => root,
        source  => 'puppet:///mcollective/client.cfg',
        require => Package['mcollective-common'],
    }

    file { '/etc/mcollective/ssl/server-private.pem':
        ensure  => present,
        mode    => 0640,
        owner   => root,
        group   => root,
        source  => 'puppet:///mcollective/server-private.pem',
        require => Package['mcollective-common'],
    }

    file { '/etc/mcollective/ssl/server-public.pem':
        ensure => present,
        mode   => $hostname ? {
            $nocnode => 0644,
            default  => 0640,
        },
        owner   => root,
        group   => root,
        source  => 'puppet:///mcollective/server-public.pem',
        require => Package['mcollective-common'],
    }

    file { '/etc/mcollective/ssl/clients/noc-public.pem':
        ensure  => present,
        mode    => 0644,
        owner   => root,
        group   => root,
        source  => 'puppet:///mcollective/noc-public.pem',
        require => [ Package['mcollective-common'], 
                     File['/etc/mcollective/ssl/clients'] ],
    }

    service { 'mcollective':
        ensure  => running,
        enable  => true,
        require => [ Package['mcollective'],
                     File['/etc/mcollective/server.cfg',
                          '/etc/mcollective/ssl/server-public.pem',
                          '/etc/mcollective/ssl/server-private.pem',
                          '/etc/mcollective/ssl/clients/noc-public.pem'], ],
    }

    $mcoplug_packages = [ 'mcollective-plugins-agentinfo',
      'mcollective-plugins-nodeinfo', 'mcollective-plugins-facter_facts',
      'mcollective-plugins-package',  'mcollective-plugins-service' ] 

    package { $mcoplug_packages:
        ensure  => installed,
        require => [ Yumrepo['kermit-custom', 'kermit-thirdpart'],
                     Package['mcollective-common'], ],
    }

    $agentsrc = $hostname ? {
        $nocnode => undef,
        default  => 'puppet:///mcoagents',
    }

    file { '/usr/libexec/mcollective/mcollective/agent':
          ensure  => directory,
          recurse => true,   # <- That's all needed --v 
          source  => $agentsrc,
          owner   => 'root',
          group   => 'root',
          require => Package['mcollective-common'],
    }

}
