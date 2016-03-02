require 'spec_helper'

describe 'janus::role::standalone' do

  describe command('lsof -P -p $(cat /var/run/janus_instance1.pid)| grep -E "IPv4+.*TCP"') do
    its(:stdout) { should match /10000+.*LISTEN\)$/ }
    its(:stdout) { should match /8300+.*LISTEN\)$/ }
  end

  describe command('lsof -P -p $(cat /var/run/janus_instance1.pid)| grep -E "IPv4+.*TCP"') do
    its(:stdout) { should match /10001+.*LISTEN\)$/ }
    its(:stdout) { should match /8343+.*LISTEN\)$/ }
  end


  describe file('/opt/janus-cluster/instance1/var/log/janus/janus.log') do
    its(:content) { should match /Plugins folder: \/opt\/janus-cluster\/instance1\/usr\/lib\/janus\/plugins.enabled/ }
    its(:content) { should match /Loading plugin 'libjanus_audioroom\.so'/ }
    its(:content) { should match /JANUS CM audio plugin initialized!/ }
  end

  describe file('/opt/janus-cluster/instance2/var/log/janus/janus.log') do
    its(:content) { should match /Plugins folder: \/opt\/janus-cluster\/instance2\/usr\/lib\/janus\/plugins.enabled/ }
    its(:content) { should match /Loading plugin 'libjanus_audioroom\.so'/ }
    its(:content) { should match /JANUS CM audio plugin initialized!/ }
  end

end
