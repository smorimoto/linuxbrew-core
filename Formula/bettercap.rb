class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.28.tar.gz"
  sha256 "5bde85117679c6ed8b5469a5271cdd5f7e541bd9187b8d0f26dee790c37e36e9"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "0614862741982083f1629e32b87d84116917e218cac936a078061b898a1e3f04" => :catalina
    sha256 "805fbdc7281828c316c6fc91454c7f101ab7be69b235b1e32aa78dbaf55da8d3" => :mojave
    sha256 "6709b0ce6657bc3732dee9079d7635dbab2450d233c57f82e5758e2d0978a38e" => :high_sierra
    sha256 "41606ab6698564a4e273a0bb754e06972d9df07e05e332b75350f9798aa4161c" => :x86_64_linux
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libnetfilter-queue" unless OS.mac?

  uses_from_macos "libpcap"

  def install
    unless OS.mac?
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["libpcap"].opt_lib/"pkgconfig"
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["libnetfilter-queue"].opt_lib/"pkgconfig"
    end
    system "make", "build"
    bin.install "bettercap"
  end

  def caveats
    <<~EOS
      bettercap requires root privileges so you will need to run `sudo bettercap`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "bettercap", shell_output("#{bin}/bettercap -help 2>&1", 2)
  end
end
