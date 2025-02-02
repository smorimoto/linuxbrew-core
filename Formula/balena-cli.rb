require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.7.0.tgz"
  sha256 "f48464426b086a5e0eb388b4e07d1412260dbe5381b62cd79fe71c608622b6e1"
  license "Apache-2.0"

  bottle do
    sha256 "12e8dd44d5fe88d66834c35e6841cffa16eb1cf876d91e83a9a6ba0f98f7d6ac" => :catalina
    sha256 "6da74df0e72ac657e659c951febdaf41b9ab4ee44115727a6e6e861c2ff20d3b" => :mojave
    sha256 "c3ffb0fc4847f494c4a1067019bdf8869763d975dd54e4e2a45d513d8603d8ec" => :high_sierra
    sha256 "59685b2acbad3fd2b0145a0f1f3ec026066d48136145f52ae9086f262c2cfb99" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
