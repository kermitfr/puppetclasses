class yum {
    file { "/etc/yum.repos.d/kermit.repo":
       ensure => present,
       mode   => 644,
       owner  => root,
       group  => root,
       source => "puppet:///modules/yum/kermit.repo"
    }
    file { "/etc/yum.repos.d/a7x.repo":
       ensure => present,
       mode   => 644,
       owner  => root,
       group  => root,
       source => "puppet:///modules/yum/a7x.repo"
    }
}

