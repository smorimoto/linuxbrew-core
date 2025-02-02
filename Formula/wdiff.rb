class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/wdiff/wdiff-1.2.2.tar.gz"
  sha256 "34ff698c870c87e6e47a838eeaaae729fa73349139fc8db12211d2a22b78af6b"
  revision 2

  bottle do
    sha256 "cd316e673c68a54b9be013a7a0fb96beba13648bd0048f7f1fd8b7a8b07ab821" => :catalina
    sha256 "89e0de3859b91c4dcdc4a9ac2ae4569f72cd472658e6d3dfa82e6acc919c68a1" => :mojave
    sha256 "579a8972310d39ac2e660f3114fc6d1536df7ad9f7659a9b00619cc7c50a2191" => :high_sierra
    sha256 "fcfe6296c4b9879895a4977274f56474faa84ca74c792866ea3149a2f02df553" => :sierra
    sha256 "915a7d9113b2cfd41dbe57344425599165b6891f4f5f0fdaf134009abf7aba73" => :x86_64_linux
  end

  depends_on "gettext"

  uses_from_macos "texinfo" => :build
  uses_from_macos "ncurses"

  conflicts_with "montage", :because => "both install an `mdiff` executable"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make", "install"
  end

  test do
    a = testpath/"a.txt"
    a.write "The missing package manager for OS X"

    b = testpath/"b.txt"
    b.write "The package manager for OS X"

    output = shell_output("#{bin}/wdiff #{a} #{b}", 1)
    assert_equal "The [-missing-] package manager for OS X", output
  end
end
