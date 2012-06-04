class jboss($up = true) {
    $jbossver = '6.1.0.Final'

    file { 'jboss.repo':
        path   => '/etc/yum.repos.d/jboss.repo',
        ensure => present,
        source => 'puppet:///jboss/jboss.repo',
        owner  => 'root',
        group  => 'root',
        mode   => 0644,
    }

    user{ 'jboss':
        comment      => 'jboss',
        ensure       => present,
        managehome   => true,
        home         => '/opt/jboss'
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
        ensure => present,
        require => Package['java-1.6.0-openjdk'],
    }
    
    #package { 'jboss-as-distribution':
    #    require => File['jboss.repo'],
    #    ensure  => present,
    #}

    #package { 'unzip':
    #    ensure => present,
    #}

    #exec { 'extract jboss':
    #    require => [ User['jboss'], Package['jboss-as-distribution'], Package['unzip'], ],
    #    command => "/usr/bin/unzip /opt/jboss-as-distribution/jboss-as-distribution-${jbossver}.zip -d /opt/jboss/",
    #    creates => "/opt/jboss/jboss-${jbossver}/bin/probe.sh",
    #    user    => 'jboss',
    #    group   => 'jboss',
    #    onlyif  => '/usr/bin/test -d /opt/jboss-as-distribution',
    #}

    file { 'jboss_service':
        ensure  => present,
        path    => '/etc/init.d/jboss',
        content => template('jboss/jboss_service'),
        owner   => 'root',
        group   => 'root',
        mode    => 0755,
    }

    service{ 'jboss':
        require   => [ File['jboss_service'], Package['jbossas'], ],
        ensure    => $up? { true => running, default => stopped },
        enable    => $up? { true => true,    default => false   },
        hasstatus => false,
    }
}
