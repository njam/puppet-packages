require 'spec_helper'

describe file('/tmp/source/foo') do
  it { should be_file }
end

describe command('monit summary | grep nfs-server') do
  it { should return_exit_status 0 }
end

describe file('/tmp/source/bar') do
  it { should be_file }
end

describe file('/nfsexport/shared/foo') do
  it { should be_file }
end

describe file('/nfsexport/shared/bar') do
  it { should be_file }
end

describe file('/tmp/mounted/foo') do
  it { should be_file }
end

describe file('/tmp/mounted/bar') do
  it { should be_file }
end
