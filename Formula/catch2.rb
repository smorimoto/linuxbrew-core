class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.12.4.tar.gz"
  sha256 "5436725bbc6ee131a0bc9545bef31f0adabbb21fbc39fb6f1b2a42c12e4f8107"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7405839bc33f35be20565a1653bc112789d0ff0ba3daeff5e9846e1f80fc76f9" => :catalina
    sha256 "7405839bc33f35be20565a1653bc112789d0ff0ba3daeff5e9846e1f80fc76f9" => :mojave
    sha256 "6b886c94c3f56a9bd999eebf6140c7a62729fc9e8e4a110495f3e06d640abcf6" => :high_sierra
    sha256 "0fd8bdcbf4b07b34237295be8e09737014d7102efe2f11348e7cea1dede5451f" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define CATCH_CONFIG_MAIN
      #include <catch2/catch.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
