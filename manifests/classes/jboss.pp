class jboss {
    $jbossver = "6.1.0.Final"

    file { "jboss.repo":
        path   => "/etc/yum.repos.d/jboss.repo",
        ensure => present,
        source => "puppet:///modules/jboss/jboss.repo",
        owner  => "root",
        group  => "root",
        mode   => "0644",
    }

    user{ "jboss":
        comment      => "jboss",
        ensure       => present,
        managehome   => true,
        home         => "/opt/jboss"
    }

    file { "jboss_profile":
        path    => "/opt/jboss/.bash_profile",
        ensure  => present,
        content => template("jboss/jboss_bash_profile"),
        owner   => "jboss",
        group   => "jboss",
        mode    => '0644',
        require => User['jboss'],
    }

    package { "java-1.6.0-openjdk":
        ensure => present,
    }
    
    package { "jboss-as-distribution":
        ensure  => present,
        require => File['jboss.repo'],
    }

    package { "unzip":
        ensure => present,
    }

    exec { "extract jboss":
        command => "/usr/bin/unzip /opt/jboss-as-distribution/jboss-as-distribution-${jbossver}.zip -d /opt/jboss/",
        creates => "/opt/jboss/jboss-${jbossver}/bin/probe.sh",
        user    => "jboss",
        group   => "jboss",
        onlyif  => "/usr/bin/test -d /opt/jboss-as-distribution",
        require => [ User['jboss'], Package['jboss-as-distribution'], Package['unzip'] ],
    }

    file { "jboss_service":
        ensure  => present,
        path    => "/etc/init.d/jboss",
        content => template("jboss/jboss_service"),
        owner   => "root",
        group   => "root",
        mode    => '0755',
    }

    service{ "jboss":
        enable    => true,
        ensure    => running,
        hasstatus => false,
        require   => File['jboss_service'],
    }

}
