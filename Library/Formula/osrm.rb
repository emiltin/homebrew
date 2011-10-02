require 'formula'

class Osrm < Formula
  #url 'http://downloads.sourceforge.net/project/routed/osrm_0.2.tar.gz'
  #md5 '4e2696e0eab9b90ca17fae183061e766'
  head 'https://github.com/DennisOSRM/Project-OSRM', :using => :git
  homepage 'http://project-osrm.org'

  depends_on 'stxxl'
  depends_on 'google-sparsehash'
  depends_on 'protobuf'

  def install
    if `which g++-4.6`.to_s == ''
      system "brew install --use-clang --enable-cxx https://github.com/adamv/homebrew-alt/raw/master/duplicates/gcc.rb"
    end
    compiler = 'g++-4.6'
    proto = 'DataStructures/pbf-proto'
    stxxl = '/usr/local/Cellar/stxxl/1.3.1'
    boost = '/usr/local/Cellar/boost/1.47.0'
    xml2 = '/usr/include/libxml2'
    cellar = '/usr/local/Cellar/osrm'
    opt = '-O3 -DNDEBUG'
    incl = "-I#{stxxl}/include -I#{xml2}"
    libs = '-fopenmp -lboost_regex-mt -lboost_iostreams-mt -lbz2 -lz -lprotobuf'
    system "protoc #{proto}/fileformat.proto -I=#{proto} --cpp_out=#{proto}"
    system "protoc #{proto}/osmformat.proto -I=#{proto} --cpp_out=#{proto}"
    system "#{compiler} -c #{proto}/fileformat.pb.cc -o #{proto}/fileformat.pb.o #{opt} -I#{cellar}"
    system "#{compiler} -c #{proto}/osmformat.pb.cc -o #{proto}/osmformat.pb.o #{opt} -I#{cellar}"
    system "#{compiler} -o osrm-extract extractor.cpp #{opt} #{incl} #{libs} -L#{stxxl}/lib -L#{proto} -lstxxl -lxml2 -losmformat.pb.o -lfileformat.pb.o"
    system "#{compiler} -o osrm-prepare createHierarchy.cpp #{opt} #{incl} #{libs} -L#{stxxl}/lib -lstxxl"
    system "#{compiler} -o routed routed.cpp #{opt} #{incl} #{libs} -L#{boost}/lib -lboost_system-mt -lboost_thread-mt "
    bin.install ['osrm-extract','osrm-prepare','routed']
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test osrm`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end