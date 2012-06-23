class kermit {
    
    include yum

    file { '/etc/kermit/':
      ensure  => directory,
    }

    file { '/etc/kermit/ssl/':
      require => File['/etc/kermit/'],
      ensure  => directory,
    }

    file { '/etc/kermit/ssl/q-private.pem':
        require => [ File['/etc/kermit/ssl/'], Package['mcollective-common'] ],
        ensure => $hostname ? {
            $recvnode => absent,
            default   => present,
        },
        mode    => 644,
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/kermit/q-private.pem',
    }

    file { '/etc/kermit/kermit.cfg':
        require => File['/etc/kermit/'],
        ensure  => present, 
        mode    => 644,
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/kermit/kermit.cfg',
    }

    file { '/etc/kermit/amqpqueue.cfg':
        require => File['/etc/kermit/'],
        ensure  => present, 
        mode    => 644,
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/kermit/amqpqueue.cfg',
    }

    $mcoreq_packages = [ 'kermit-gpg_key_whs', 'kermit-mqsend',
        'rubygem-curb', 'rubygem-inifile', 'rubygem-json',
        'rubygem-xml-simple', 'rubygem-ruby-rpm', 'rubygem-rubyzip' ] 

    package { $mcoreq_packages: 
        require => Yumrepo['kermit-custom', 'kermit-thirdpart'],
        ensure  => present,
    }

    file { '/usr/local/bin/kermit':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file { '/usr/local/bin/kermit/queue':
        require => File['/usr/local/bin/kermit'],
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }
}

