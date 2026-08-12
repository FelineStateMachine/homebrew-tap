class Devsite < Formula
  desc "Share public work and reach local TCP services"
  homepage "https://dev.site"
  url "https://github.com/FelineStateMachine/devsite/releases/download/v0.5.0/devsite-v0.5.0-aarch64-apple-darwin.tar.gz"
  sha256 "52bc3b49c1bcae22cba45e3ce1c068efd0adcdbff546047348365ccc074b5503"
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
