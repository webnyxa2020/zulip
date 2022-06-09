class zulip::common {
  # Common parameters
  case $::os['family'] {
    'Debian': {
      $nagios_plugins = 'monitoring-plugins-basic'
      $nagios_plugins_dir = '/usr/lib/nagios/plugins'
      $nginx = 'nginx-full'
      $supervisor_system_conf_dir = '/etc/supervisor/conf.d'
      $supervisor_conf_file = '/etc/supervisor/supervisord.conf'
      $supervisor_service = 'supervisor'
      $supervisor_start = '/etc/init.d/supervisor start'
      # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=877086
      # "restart" is actually "stop" under sysvinit
      $supervisor_reload = '/etc/init.d/supervisor restart && (/etc/init.d/supervisor start || /bin/true) && /etc/init.d/supervisor status'
      $supervisor_status = '/etc/init.d/supervisor status'
    }
    'RedHat': {
      $nagios_plugins = 'nagios-plugins'
      $nagios_plugins_dir = '/usr/lib64/nagios/plugins'
      $nginx = 'nginx'
      $supervisor_system_conf_dir = '/etc/supervisord.d/conf.d'
      $supervisor_conf_file = '/etc/supervisord.conf'
      $supervisor_service = 'supervisord'
      $supervisor_start = 'systemctl start supervisord'
      $supervisor_reload = 'systemctl reload supervisord'
      $supervisor_status = 'systemctl status supervisord'
    }
    default: {
      fail('osfamily not supported')
    }
  }
  $supervisor_conf_dir = "${supervisor_system_conf_dir}/zulip"

  $total_memory_bytes = $::memory['system']['total_bytes']
  $total_memory_mb = $total_memory_bytes / 1024 / 1024

  $goarch = $::os['architecture'] ? {
    'amd64'   => 'amd64',
    'aarch64' => 'arm64',
  }

  $versions = {
    # https://github.com/cactus/go-camo/releases
    'go-camo' => {
      'version'   => '2.4.0',
      'goversion' => '1176',
      'sha256'    => {
        'amd64'   => '0033c412d1da09caca1774d2a7e3de3ec281e0450d67c574846f167ce253b67c',
        'aarch64' => '81bdf24e769cdf9a8bd2c5d9ecc633437eb3b22be73bdc10e03e517dd887b2b7',
      },
    },

    # https://go.dev/dl/
    'golang' => {
      'version' => '1.17.6',
      'sha256' => {
        'amd64'   => '231654bbf2dab3d86c1619ce799e77b03d96f9b50770297c8f4dff8836fc8ca2',
        'aarch64' => '82c1a033cce9bc1b47073fd6285233133040f0378439f3c4659fe77cc534622a',
      },
    },

    # https://github.com/stripe/smokescreen/tags
    'smokescreen-src' => {
      'version' => '96dc8b043d3f22dcb65a9c2ccf22e3794e2da3a1',
      # Source code, so arch-invariant sha256
      'sha256' => 'c2b8080999c3ba9e2b509f8d4cf300922557e7c070fb16ac7d1ea220416f8660',
    },

    # https://github.com/wal-g/wal-g/releases
    'wal-g' => {
      'version' => '1.1.1-rc',
      'sha256' => {
        'amd64' => 'eed4de63c2657add6e0fe70f8c0fbe62a4a54405b9bfc801b1912b6c4f2c7107',
        # No aarch64 builds
      },
    },


    ### zulip_ops packages

    # https://grafana.com/grafana/download?edition=oss
    'grafana' => {
      'version' => '8.3.6',
      'sha256' => {
        'amd64'   => 'f2047de7ec42243ddedb95b16e6b5704cb12ec775b07ebf0adc67db00a52c459',
        'aarch64' => 'd7dfdc1d08499f19b84b51f878d5380ba293468cf753420ce25caf423fb7231a',
      },
    },

    # https://prometheus.io/download/#node_exporter
    'node_exporter' => {
      'version' => '1.3.1',
      'sha256' => {
        'amd64'   => '68f3802c2dd3980667e4ba65ea2e1fb03f4a4ba026cca375f15a0390ff850949',
        'aarch64' => 'f19f35175f87d41545fa7d4657e834e3a37c1fe69f3bf56bc031a256117764e7',
      },
    },

    # https://prometheus.io/download/#prometheus
    'prometheus' => {
      'version' => '2.33.1',
      'sha256' => {
        'amd64'   => '55de29727fc4d3977d3400c54fa222ebb52755bd0201936f1e1052fea6f2b44b',
        'aarch64' => '21d89df7a98882a1a872bd3210aeaac3915a7f7be9f2ad28c986c80ad64ee77d',
      },
    },

    # https://github.com/timonwong/uwsgi_exporter/releases
    'uwsgi_exporter' => {
      'version' => '1.0.0',
      'sha256' => {
        'amd64'   => '7e924dec77bca1052b4782dcf31f0c6b2ebe71d6bf4a72412b97fec45962cef0',
        'aarch64' => 'b36e26c8e94f1954c76aa9e9920be2f84ecc12b34f14a81086fedade8c48cb74',
      },
    },
  }
}
