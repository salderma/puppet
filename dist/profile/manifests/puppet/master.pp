# Puppet Master Class
class profile::puppet::master {
  # Hiera config
  $hiera_data_dir = "${::settings::environmentpath}/%{::environment}/hieradata"
  class {'::hiera':
    datadir            => $hiera_data_dir,
    hiera_yaml         => "${::settings::codedir}/hiera.yaml",
    puppet_conf_manage => false,
    create_symlink     => false,
    owner              => 'root',
    group              => 'root',
    hierarchy          => [
      'nodes/%{::trusted.certname}',
      '%{::trusted.domainname}/%{::trusted.hostname}',
      'roles/%{::trusted.extensions.pp_role}',
      'roles/%{::role}',
      'projects/%{::trusted.extensions.pp_project}',
      'projects/%{::project}',
      'virtual/%{::virtual}',
      'osfamily/%{::osfamily}',
      'private',
      'common',
    ],
  }

  # Install, configure and run R10K
  $control_repo = hiera('control_repo')
  $r10k_version = hiera('r10k_version', 'latest')
  class {'::r10k':
    sources  => {
      'main' => {
        'remote'  => $control_repo,
        'basedir' => $::settings::environmentpath,
        'prefix'  => false,
      },
    },
    cachedir => '/opt/puppetlabs/r10k/cache',
    provider => 'puppet_gem',
    version  => $r10k_version,
    notify   => Exec['R10K deploy environment'],
  }

  # Deploy R10K environment
  exec {'R10K deploy environment':
    command   => '/opt/puppetlabs/puppet/bin/r10k deploy environment --puppetfile --verbose',
    creates   => "${::settings::environmentpath}/production/Puppetfile",
    logoutput => true,
    timeout   => 600,
    require   => Package['r10k'],
  }
}
