require 'formula'

class Stxxl < Formula
  url 'http://sourceforge.net/projects/stxxl/files/stxxl/1.3.1/stxxl-1.3.1.tar.gz'
  homepage 'http://stxxl.sourceforge.net/'
  md5 '8d0e8544c4c830cf9ae81c39b092438c'
  
  keg_only "Stxxl is a library of C++ classes and has no binaries."
  
  def install
    system "make config_gnu"
    system "make library_g++"
    prefix.install Dir['*']
  end
end
