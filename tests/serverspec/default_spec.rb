require "spec_helper"
require "serverspec"

package = "nfs_server_openbsd"
service = "nfs_server_openbsd"
config  = "/etc/nfs_server_openbsd/nfs_server_openbsd.conf"
user    = "nfs_server_openbsd"
group   = "nfs_server_openbsd"
ports   = [PORTS]
log_dir = "/var/log/nfs_server_openbsd"
db_dir  = "/var/lib/nfs_server_openbsd"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/nfs_server_openbsd.conf"
  db_dir = "/var/db/nfs_server_openbsd"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("nfs_server_openbsd") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/nfs_server_openbsd") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
