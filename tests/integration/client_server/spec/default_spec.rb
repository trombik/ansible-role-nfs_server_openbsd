require "spec_helper"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]

context "after provisioning finished" do
  describe server(:client1) do
    it "should be able to ping server" do
      result = current_server.ssh_exec("ping -c 1 #{server(:server1).server.address} && echo OK")
      expect(result).to match(/OK/)
    end

    it "mounts /usr/ports/packages" do
      result = current_server.ssh_exec("sudo mount -t nfs #{server(:server1).server.address}:/usr/ports/packages /usr/ports/packages && echo OK")
      expect(result).to match(/OK/)
    end

    it "reads README" do
      result = current_server.ssh_exec("cat /usr/ports/packages/amd64/all/README")
      expect(result).to match(/Permission to use, copy, modify, and distribute this software for any/)
    end

    it "fails to write under /usr/ports/packages" do
      result = current_server.ssh_exec("sudo touch /usr/ports/packages/foo")
      expect(result).to match(%r{touch: /usr/ports/packages/foo: Permission denied})
    end

    it "umounts /usr/ports/packages" do
      result = current_server.ssh_exec("sudo umount /usr/ports/packages && echo OK")
      expect(result).to match(/OK/)
    end

    it "mounts /tmp/upload on /mnt" do
      result = current_server.ssh_exec("sudo mount #{server(:server1).server.address}:/tmp/upload /mnt && echo OK")
      expect(result).to match(/OK/)
    end

    it "creates /mnt/foo" do
      result = current_server.ssh_exec("sudo touch /mnt/foo && echo OK")
      expect(result).to match(/OK/)
    end

    it "umounts /tmp/upload" do
      result = current_server.ssh_exec("sudo umount /mnt && echo OK")
      expect(result).to match(/OK/)
    end
  end

  describe server(:server1) do
    it "should be able to ping client" do
      result = current_server.ssh_exec("ping -c 1 #{server(:client1).server.address} && echo OK")
      expect(result).to match(/OK/)
    end

    it "finds a file, /tmp/upload/foo" do
      result = current_server.ssh_exec("stat /tmp/upload/foo")
      expect(result).to match(/^\d+ \d+ -rw-r--r-- 1 nobody nobody/)
    end

    it "removes /tmp/upload/foo" do
      result = current_server.ssh_exec("sudo rm /tmp/upload/foo && echo OK")
      expect(result).to match(/OK/)
    end
  end
end
