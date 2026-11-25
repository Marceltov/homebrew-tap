class Calfeed < Formula
  desc "Serve your Mac's calendars as local iCal feeds (e.g. for Super Productivity)"
  homepage "https://github.com/Marceltov/calfeed"
  url "https://github.com/Marceltov/calfeed/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "883bde9627a1682df514eff4f354f5e0fa9729cb6c29850070eaa1b4c27fc53a"
  license "MIT"

  depends_on :macos

  def install
    # Builds and ad-hoc signs CalFeed.app: macOS only grants calendar access to a signed app bundle.
    system "./scripts/build-app.sh", buildpath/"build"
    prefix.install "build/CalFeed.app"
    bin.write_exec_script prefix/"CalFeed.app/Contents/MacOS/CalFeed"
  end

  def caveats
    <<~EOS
      Start CalFeed in the background (also after a restart):
        brew services start calfeed
      Then allow calendar access when macOS asks, and open http://localhost:8765/
      After `brew upgrade calfeed`, macOS may ask for calendar access again.
    EOS
  end

  service do
    run [opt_prefix/"CalFeed.app/Contents/MacOS/CalFeed", "--port", "8765"]
    keep_alive true
    log_path var/"log/calfeed.log"
    error_log_path var/"log/calfeed.log"
  end

  test do
    assert_equal "CalFeed #{version}", shell_output("#{prefix}/CalFeed.app/Contents/MacOS/CalFeed --version").strip
  end
end
