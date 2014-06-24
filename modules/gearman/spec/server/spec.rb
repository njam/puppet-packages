require 'spec_helper'

describe user('gearman') do
  it { should exist }
end

describe command('/usr/sbin/gearmand --version') do
  its(:stdout) { should match('1.1.12') }
end

describe service('gearman-job-server') do
  it { should be_enabled }
  it { should be_running }
end

describe port(4730) do
  it { should be_listening }
end

describe file('/etc/default/gearman-job-server') do
  it { should be_file }
  its(:content) { should match /--job-retries=25/ }
end
