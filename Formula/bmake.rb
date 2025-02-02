class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200704.tar.gz"
  sha256 "d85f25fcb335ca4618480f48f4969a841ea073054d52b16d6fe47765dda3c51c"

  bottle do
    sha256 "c38faae30ac15a10eb003a9f73b97505b6b05da99e740c09d5d246d88e18581b" => :catalina
    sha256 "24630b2df6309d587373d73d2f08edc0a63b7d08015eb3a82f1a4b0f9de1bfa9" => :mojave
    sha256 "da7078544237d564c67a05ce966c0d32adf53532072cfb5e5b224c06b2c942e8" => :high_sierra
    sha256 "19980e5553633beec9be81aed31d9449b6277283e4cb48c9eeae7051b067df06" => :x86_64_linux
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
    system "sh", "boot-strap", *args

    chmod "u+w", man1/"bmake.1"
    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
