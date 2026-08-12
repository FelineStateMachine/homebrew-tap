class Devsite < Formula
  desc "Share public work and reach local TCP services"
  homepage "https://dev.site"
  url "https://github.com/FelineStateMachine/devsite/releases/download/v0.3.1/devsite-v0.3.1-aarch64-apple-darwin.tar.gz"
  sha256 "cb919791f90f41688ea70d92f9ca0853facc11035f4fd1460dfd7c83eb9d97ae"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "devsite"
  end

  service do
    run [opt_bin/"devsite", "daemon", "run"]
    keep_alive true
    log_path var/"log/devsite.log"
    error_log_path var/"log/devsite.log"
  end

  test do
    assert_match(/^devsite \d+\.\d+\.\d+$/, shell_output("#{bin}/devsite --version").strip)
    assert_match "status", shell_output("#{bin}/devsite daemon --help")
    output = shell_output("DEVSITE_HOME=#{testpath}/home #{bin}/devsite --json status")
    assert_match '"command":"status"', output
    assert_match '"ok":true', output
  end
end
