class php5::extension::apcu (
  $version = '4.0.4',
  $configureParams = ''
) {

  require 'build'
  require 'php5'

  helper::script {'install php5::apcu':
    content => template('php5/extension/apcu/install.sh'),
    unless => "php --re apcu | grep 'apcu version' | grep ' ${version} '",
    require => Class['php5'],
  }
  ->

  php5::config_extension {'apcu':
    content => template('php5/extension/apcu/conf.ini'),
  }
}
