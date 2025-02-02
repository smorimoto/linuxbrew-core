class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.7.0.tar.gz"
  sha256 "f0114a4d3c88be9e696762f37a7c379619443ce9d668546c61b21d41affe5b62"
  head "https://github.com/gabime/spdlog.git", :branch => "v1.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "71af7c09d04504baf8c310e32ebacb45262bc78beaebd80deaf44bfda3d2d807" => :catalina
    sha256 "414bbd020a107884d56adc42e89d6e43d14e9b42c32fe4c845022d0dee886b85" => :mojave
    sha256 "da30ba8690195fd103a10b53838dc67ed253893b2d1e6503d964739b0029dc1c" => :high_sierra
    sha256 "9aab8724dac0f3d8d340527e3ad330bb973609c280d681d5f8be0b3b60df6a8c" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "spdlog-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << "-DSPDLOG_BUILD_BENCH=OFF" << "-DSPDLOG_BUILD_TESTS=OFF" << ".."
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "spdlog/sinks/basic_file_sink.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        try {
          auto console = spdlog::basic_logger_mt("basic_logger", "#{testpath}/basic-log.txt");
          console->info("Test");
        }
        catch (const spdlog::spdlog_ex &ex)
        {
          std::cout << "Log init failed: " << ex.what() << std::endl;
          return 1;
        }
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
