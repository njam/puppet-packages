require 'spec_helper'

describe 'php5::extension::imagick' do

  describe command('php --ri imagick') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /Imagick compiled with ImageMagick version => ImageMagick 6\.9/}
  end

  describe command('php -r "echo join(PHP_EOL, Imagick::queryformats());"') do
    its(:stdout) { should match('^JPEG$') }
    its(:stdout) { should match('^PNG$') }
    its(:stdout) { should match('^SVG$') }
  end

end
