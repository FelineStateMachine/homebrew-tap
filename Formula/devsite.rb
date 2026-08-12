class Devsite < Formula
  desc "Share public work and reach local TCP services"
  homepage "https://dev.site"
  license "Apache-2.0"
  head "https://github.com/FelineStateMachine/devsite.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/devsite-cli")
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
