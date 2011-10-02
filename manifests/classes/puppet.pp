class puppet {
    package { "puppet": 
            ensure => installed 
    }

    service { "puppet":
        ensure => running,
        enable => true,
        require => Package["puppet"]
    }
}

