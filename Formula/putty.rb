class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.74/putty-0.74.tar.gz"
  sha256 "ddd5d388e51dd9e6e294005b30037f6ae802239a44c9dc9808c779e6d11b847d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5e454c08c5d06394527aa7141a332eb721097068f25deff3b4affa847837178" => :catalina
    sha256 "5f9844fc7464fefd987780b3579a33b2ca37673be56c2a8249c312a19e20faea" => :mojave
    sha256 "6621f31a41a8eedbbb2fda99a0548deed80d432216469105bac8084df66dbcbf" => :high_sierra
    sha256 "a653c9c394ab341c3b9fa7434a21b56adf9e651c7eb49f9b01cf4e248b9f91cb" => :x86_64_linux
  end

  head do
    url "https://git.tartarus.org/simon/putty.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "halibut" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "expect" => :test

  conflicts_with "pssh", :because => "both install `pscp` binaries"

  def install
    if build.head?
      system "./mkfiles.pl"
      system "./mkauto.sh"
      system "make", "-C", "doc"
    end

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-gtktest
      --without-gtk
    ]

    system "./configure", *args

    build_version = build.head? ? "svn-#{version}" : version
    system "make", "VER=-DRELEASE=#{build_version}"

    bin.install %w[plink pscp psftp puttygen]

    cd "doc" do
      man1.install %w[plink.1 pscp.1 psftp.1 puttygen.1]
    end
  end

  test do
    expect_path = if OS.mac?
      "/usr/bin/expect"
    else
      Formula["expect"].opt_bin/"expect"
    end
    (testpath/"command.sh").write <<~EOS
      #!#{expect_path} -f
      set timeout -1
      spawn #{bin}/puttygen -t rsa -b 4096 -q -o test.key
      expect -exact "Enter passphrase to save key: "
      send -- "Homebrew\n"
      expect -exact "\r
      Re-enter passphrase to verify: "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system "./command.sh"
    assert_predicate testpath/"test.key", :exist?
  end
end
