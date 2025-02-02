class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.5.tar.gz"
  sha256 "65d46fd0e4f8bf513d436a4700b63da91696da8cb5a4e53d971ba0c95d5c30af"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b966aedf1215797f6dc81ceed0d1621c6f8103b45c5f0066594fcb9f34db383" => :catalina
    sha256 "39bed96de6223fd46770bdfcd8140cac5c35ae3ae58ec8802fc8904063d3dbb7" => :mojave
    sha256 "6bca7f61de13a5f4847e17d1e0a707ae8af8b9708f55ba452c93359688f2a1dd" => :high_sierra
    sha256 "98924e95d7b102c3524be5442c63dc75c886d372d2c005bf3f2d71f40cfa7375" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
