class jboss($up = true) {
    $jbossver = '6.1.0.Final'

    yumrepo { "jboss":
       baseurl   =>
         "http://www.kermit.fr/repo/rpm/el\$releasever/\$basearch/jboss/",
       descr     => "JBoss",
       enabled   => 1,
       gpgcheck  => 0,
    }    

    user{ 'jboss':
        comment      => 'jboss',
        ensure       => present,
        managehome   => true,
        home         => '/opt/jboss',
    }

    file { 'jboss_profile':
        require => User['jboss'],
        path    => '/opt/jboss/.bash_profile',
        ensure  => present,
        content => template('jboss/jboss_bash_profile'),
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
    }

    package { 'java-1.6.0-openjdk':
        ensure => present,
    }

    package { 'jbossas':
        ensure  => present,
        require => Package['java-1.6.0-openjdk'],
    }
    
    file { 'jboss_service':
        ensure  => present,
        path    => '/etc/init.d/jboss',
        content => template('jboss/jboss_service'),
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    service{ 'jboss':
        require   => [ File['jboss_service'], Package['jbossas'], ],
        ensure    => $up? { true => running, default => stopped },
        enable    => $up? { true => true,    default => false   },
        hasstatus => false,
    }
}
