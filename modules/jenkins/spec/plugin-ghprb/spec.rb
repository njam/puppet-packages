require 'spec_helper'

describe 'jenkins::plugin::ghprb' do

  describe file('/var/lib/jenkins/org.jenkinsci.plugins.ghprb.GhprbTrigger.xml') do
    its(:content) { should match /<accessToken>xxx<\/accessToken>/ }
    its(:content) { should match /<adminlist>foo bar<\/adminlist>/ }
  end
end
