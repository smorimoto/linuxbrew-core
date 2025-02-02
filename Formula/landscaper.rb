class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag      => "v1.0.24",
      :revision => "1199b098bcabc729c885007d868f38b2cf8d2370"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74decffaf180e0e0dd9bfa2312877da01443a3418afe0f485c1b655c4af1da41" => :catalina
    sha256 "ff82cdb7be6329f9a4a5ce34bcbb04bc9356ab46fa3ecd30b830cf35df268529" => :mojave
    sha256 "68302c1748fe4eb063855df24420a8681a54b8ce484f2e030616bd4c4a812d52" => :high_sierra
    sha256 "6f860ab3aeb8f760ef14307e0ae93b680101857070512066ffe955d5ffb1a88b" => :x86_64_linux
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "helm@2"
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    ENV["TARGETS"] = "darwin/amd64"
    dir = buildpath/"src/github.com/eneco/landscaper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"
      bin.install "build/landscaper"
      bin.env_script_all_files(libexec/"bin", :PATH => "#{Formula["helm@2"].opt_bin}:$PATH")
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/landscaper apply --dry-run 2>&1", 1)
    assert_match "This is Landscaper v#{version}", output
    assert_match "dryRun=true", output
  end
end
