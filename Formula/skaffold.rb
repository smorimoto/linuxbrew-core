class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v1.12.0",
      :revision => "e680a831292e1c7efc54e0c6d40544ae141e6354"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a65ba65d09aca5b697659f58f82bc8bd7d34ae7872da49f016b7070cbb618579" => :catalina
    sha256 "974c2373082bffc216eee09d615d4092c8a6c88ead8ecb335c6b6fa7c33d072f" => :mojave
    sha256 "f2e08dfbfb815b67a93e88c6640ed44041b5bbd92025e5077af9c7f581cc51dc" => :high_sierra
    sha256 "b43ddb37c5154444cc6ab16fd08c237be58a580975d71388a7544faa49401d86" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"

      output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
      (bash_completion/"skaffold").write output

      output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
      (zsh_completion/"_skaffold").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
