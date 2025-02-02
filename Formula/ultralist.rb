class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/0.9.7.tar.gz"
  sha256 "cfc5740c717eca2410cfbd3c77c03ffd33f7e4f828ecef924c2f6c4b6e73dba9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c1c484137baf1be16e5582285b8b66bc4e29b324609a577740af3c969b0a21e" => :catalina
    sha256 "a31c67179fa04dbd69aa933012cc966963f8f70409af0f6c52526c092364ff58" => :mojave
    sha256 "ce141acbf7f825124d9b129787f5add4e3653ac21119efb1188624b586fd17fe" => :high_sierra
    sha256 "1a210ec77fc2d678714490f65318b743de8b5eb927fd164f453dfcf8eefdec81" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ultralist/").mkpath
    ln_s buildpath, buildpath/"src/github.com/ultralist/ultralist"
    system "go", "build", "-o", bin/"ultralist", "./src/github.com/ultralist/ultralist"
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
