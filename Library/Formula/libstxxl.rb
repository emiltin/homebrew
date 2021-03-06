require 'formula'

class Libstxxl < Formula
  homepage 'http://stxxl.sourceforge.net/'
  url 'http://sourceforge.net/projects/stxxl/files/stxxl/1.3.1/stxxl-1.3.1.tar.gz'
  md5 '8d0e8544c4c830cf9ae81c39b092438c'
  
  keg_only "Stxxl is a library of C++ classes and has no binaries."
  
  def install
    system "make", "config_gnu"
    inreplace "Makefile" do |s|
      s.change_make_var! "USE_MACOSX", "yes"
    end
    system "make library_g++"
    prefix.install Dir['include']
    lib.install 'lib/libstxxl.a'
  end
end
