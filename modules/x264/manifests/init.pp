class x264 ($version = '20131202-2245') {

  require 'build'
  require 'yasm'

  helper::script { 'install x264':
    content => template("${module_name}/install.sh"),
    unless  => 'test -x /usr/local/bin/x264',
  }

}
