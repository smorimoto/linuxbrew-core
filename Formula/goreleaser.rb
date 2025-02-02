class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.139.0",
      :revision => "752d4e5435468a9c4b9e911840101d2af2f5acaa"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6822c33f552ce79bfac47ddbc3cb09aa2e138f142a05891c4a70dcdc5a92c822" => :catalina
    sha256 "9f06b02ebe62611581e67bcd75c2ba92f1f2ac647e99d0f94a580f1a49d69436" => :mojave
    sha256 "d81d76cda82857154be4fb5aac3a413514f2cb30b0ace921e75dd0107bee036b" => :high_sierra
    sha256 "a3054a018d92cc1da1e5a9717b28a7e8164cb8db48fc851e3fce43e86eece16a" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
