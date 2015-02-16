require 'spec_helper'

describe 'mongodb::mongos' do

  describe package('mongodb-org-server') do
    it { should be_installed.by('apt') }
  end

  describe package('mongodb-org-shell') do
    it { should be_installed.by('apt') }
  end

  describe user('mongodb') do
    it { should exist }
    it { should belong_to_group 'mongodb' }
  end

  describe service('mongos_router') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mongod$') do
    it { should_not be_enabled }
  end

  describe file('/etc/mongodb/mongos_router.conf') do
    its(:content) { should_not match /bind_ip/ }
  end

  describe file('/etc/mongod.conf') do
    it { should_not be_file }
  end

  describe port(27017) do
    it { should be_listening.with('tcp') }
  end

  describe file('/etc/logrotate.d/mongos_router') do
    it { should be_file }
    it { should contain 'cat /var/run/mongos_router.pid' }
  end

  describe command('logrotate -d /etc/logrotate.d/mongos_router') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/etc/logrotate.d/mongod_config') do
    it { should be_file }
    it { should contain 'cat /var/run/mongod_config.pid' }
  end

  describe command('logrotate -d /etc/logrotate.d/mongod_config') do
    its(:exit_status) { should eq 0 }
  end
end
