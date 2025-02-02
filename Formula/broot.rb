class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.18.5.tar.gz"
  sha256 "ec63f8223dcf7039cc9921ee9cc4a5b3196abb8df2b25a9c3dad3307db662770"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb5654980ae7ebb65d316f4575b5c6cfe2b772f2761314f242d83a626b71ea94" => :catalina
    sha256 "036afbc552a76e9139cc9adbfe5033aa869e6e2a2ac417a5add1afdcb60f3118" => :mojave
    sha256 "9eceac344c308c1ce36d880cd8a78f7bda0a837679719de16d34a48e5ec60655" => :high_sierra
    sha256 "f0895c3dcda189bd8cc91f9c33b8205c7e588b30646a115ea948060dea5b0079" => :x86_64_linux
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    return if !OS.mac? && ENV["CI"]

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", :err => :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
