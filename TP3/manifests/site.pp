node default {
  file {'/home/vagrant/4dvop-app/TP3/README':
  ensure => file,
  content => 'this is a readme',
  owner => 'root',
  }
}
yum::install { 'nginx':
  ensure => present,
  source => 'http://nginx.org/packages/centos/7/x86_64/RPMS/nginx-1.18.0-1.el7.ngx.x86_64.rpm',
}

yum::install { 'haproxy':
  ensure => present,
  source => 'http://mirror.centos.org/centos/7/os/x86_64/Packages/haproxy-1.5.18-9.el7.x86_64.rpm',
}

exec { "copy files":
  command  => "/usr/bin/cp /home/vagrant/4dvop-app/TP3/files/haproxy.cfg /etc/haproxy/haproxy.cfg",
}

tidy { '/usr/share/nginx/html/':
  rmdirs => true,
}

vcsrepo { '/usr/share/nginx/html/':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/diranetafen/static-website-example.git',
}

firewalld_service {'Allow https in the public Zone':
    ensure  => present,
    zone    => 'public',
    service => 'https',
}

firewalld_service {'Allow http in the public Zone':
    ensure  => present,
    zone    => 'public',
    service => 'http',
}

file_line { '/etc/nginx/conf.d/default.conf':
  ensure => present,
  path   => '/etc/nginx/conf.d/default.conf',
  line   => '    listen       8080;',
  match  => '    listen       80;',
}

service { 'nginx':
  ensure => running,
  enable => true,
}

service { 'haproxy':
  ensure => running,
  enable => true,
}
