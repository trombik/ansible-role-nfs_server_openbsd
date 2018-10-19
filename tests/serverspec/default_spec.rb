require "spec_helper"
require "serverspec"

ports = [111, 2049]

describe file("/etc/exports") do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "wheel" }
  its(:content) { should match(/^# Managed by ansible$/) }
  its(:content) { should match Regexp.escape("/docs -alldirs -ro -network=10.0.0 -mask=255.255.255.0") }
end

describe file "/etc/rc.conf.local" do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "wheel" }
  its(:content) { should match(/^nfsd_flags=-tun 7$/) }
end

%w[portmap mountd nfsd].each do |service|
  describe service(service) do
    it { should be_running }
    it { should be_enabled }
  end
end

describe command "rpcinfo -p" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  #     100000    2   tcp    111  portmapper
  #     100003    3   tcp   2049  nfs
  #     100005    3   tcp    957  mountd
  its(:stdout) { should match(/^\s+\d+\s+\d+\s+(tcp|udp)\s+111\s+portmapper$/) }
  its(:stdout) { should match(/^\s+\d+\s+\d+\s+(tcp|udp)\s+2049\s+nfs$/) }
  its(:stdout) { should match(/^\s+\d+\s+\d+\s+(tcp|udp)\s+\d+\s+mountd$/) }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
