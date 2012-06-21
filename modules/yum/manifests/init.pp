class yum {
    yumrepo { 'kermit-custom' :
	baseurl  =>
          'http://www.kermit.fr/repo/rpm/el$releasever/$basearch/custom/', 
        descr    => 'Kermit - Custom',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'http://www.kermit.fr/stuff/gpg/RPM-GPG-KEY-lcoilliot',
    }
 
    yumrepo { 'kermit-thirdpart' :
        baseurl  => 
          'http://www.kermit.fr/repo/rpm/el$releasever/$basearch/thirdpart/',
        descr    => 'Kermit - thirdpart',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'http://www.kermit.fr/stuff/gpg/RPM-GPG-KEY-lcoilliot', 
    }
}

