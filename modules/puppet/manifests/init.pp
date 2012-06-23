class puppet {
    $rubyshadow = $operatingsystem ? {
        'Ubuntu'  => 'libshadow-ruby1.8',
        default   => 'ruby-shadow',
    }

    package { 'ruby-shadow':
        name      => $rubyshadow,
        ensure    => installed,
    }

    package { 'puppet': 
        ensure    => installed, 
    }

    service { 'puppet':
        require   => Package['puppet'],
        ensure    => running,
        enable    => true,
        subscribe => File['/etc/puppet/puppet.conf'],
    }

    file { '/etc/puppet/puppet.conf':
        ensure    => present,
        source    => 'puppet:///modules/puppet/puppet.conf',
        owner     => 'root',
        group     => 'root',
        mode      => 0644,
    }


    file{"/var/lib/puppet/pupenv.txt":
       owner    => root,
       group    => root,
       mode     => 444,
       loglevel => debug,
       content  => inline_template("<%= scope.to_hash['environment'] %>")
    }
}

