class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.11.2.tar.gz"
  sha256 "33874c81387f03fe1a27c64cb6fb585a458c1a2c1548b4b86694da5f81164355"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "7eddb409c7bb2784db21756e624a18b19977bb4df53ab547eaedd8abe876651e" => :catalina
    sha256 "3101ea25ce49c3ed96b3c8595a5441fec3aeb536b56eca21c1dea56f6c1fd86b" => :mojave
    sha256 "8454f5aa9b8832908b1c889531118ea058b2e675ef7f7f37eeb282f454aeec1e" => :high_sierra
    sha256 "237bab11bbcc4434a0b48c8d03a6f8634d12ec011f9357f26d8965f523fedad2" => :x86_64_linux
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/shyiko/jabba"
    dir.install buildpath.children
    cd dir do
      ldflags = "-X main.version=#{version}"
      system "glide", "install"
      system "go", "build", "-ldflags", ldflags, "-o", bin/"jabba"
      prefix.install_metafiles
    end
  end

  test do
    ENV["JABBA_HOME"] = testpath/"jabba_home"
    system bin/"jabba", "install", "openjdk@1.14.0"
    jdk_path = shell_output("#{bin}/jabba which openjdk@1.14.0").strip
    assert_match 'openjdk version "14',
      shell_output("#{jdk_path}#{OS.mac? ? "/Contents/Home/" : "/"}bin/java -version 2>&1")
  end
end
