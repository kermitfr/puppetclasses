$recvnode = 'el5'
$nocnode  = 'el5'

node default {
    include yum
    include puppet
    include mcollective
    include kermit
}

