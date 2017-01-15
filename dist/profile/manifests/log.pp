# Centralized Logging Profile
class profile::log (
  Optional[String] $server_address = undef,
  Optional[Integer] $server_port = undef,
) {
  # Logs
  if $facts['os']['name'] == 'Ubuntu' {
    class {'rsyslog': purge_rsyslog_d => true,}
  }

  if ($server_address and $server_port) {
    class{'::rsyslog::client':
      log_local => true,
      remote_servers => [
        {
          host    => $server_address,
          port    => $server_port,
          pattern => '*.*',
        },
      ],
    }

    # Extra monitored files
    hiera_hash('profile::rsyslog::imfile', {}).each |String $name, Hash $params| {
      rsyslog::imfile { $name:
        * => $params;
      }
    }
  }
}
