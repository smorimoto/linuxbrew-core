class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v2.0.0.tar.gz"
  sha256 "c7ebc5650e7d5d8945fc004056bffea06e8278e54053b3dacd2d2daaac242565"

  bottle do
    cellar :any_skip_relocation
    sha256 "12f9cb755703e43d3cd9a0cb0fe180f523957f938a9ad2230ce4b331055ef131" => :catalina
    sha256 "eb1b00f5b35be71648ba4ad3c5aac6d4e784e198995a2fc2b0f65541e249a3d7" => :mojave
    sha256 "7ecf4f59a02475ac05c13a3d2354c1253ca09367d4d007b639b06640a432dc79" => :high_sierra
    sha256 "034ecabc38126d84ed98f1ee375ac4aac4ba0b0e6f910fee8962825b05711e6f" => :x86_64_linux
  end

  depends_on "python@3.8"

  conflicts_with "boost-build", :because => "both install `b2` binaries"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "b2"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end
