require 'formula'

class Osrm < Formula
  #url 'http://downloads.sourceforge.net/project/routed/osrm_0.2.tar.gz'
  #md5 '4e2696e0eab9b90ca17fae183061e766'
  if ARGV.include? '--local'
    head '/Users/emil/code/Project-OSRM/.git', :using => :git
  elsif ARGV.include? '--emil'
    head 'https://github.com/emiltin/Project-OSRM', :using => :git
  else
    head 'https://github.com/DennisOSRM/Project-OSRM', :using => :git
  end
  homepage 'http://project-osrm.org'

  depends_on 'google-sparsehash'
  depends_on 'protobuf'
  depends_on 'boost'
  depends_on 'boost-jam'

  def options
    [
      ['--latest_gcc', "Build the latest GCC, then use that to build OSRM",
       '--local', "Fetch from local repo",
       '--emil', "Fetch from https://raw.github.com/emiltin"],
    ]
  end

  def install  
    #the stxxl formula isn't yet accepted into the main brew repo, so we install from an alternative repo
    unless Formula.factory('libstxxl').installed?
      system "brew install https://raw.github.com/emiltin/homebrew/master/Library/Formula/libstxxl.rb"
    end
    
    if ARGV.include? '--latest_gcc'
      #build gcc 4.6 if not already install, then use that to build osrm. use OpenMP
      unless Formula.factory('gcc').installed?
        system "brew install --use-clang --enable-cxx https://github.com/adamv/homebrew-alt/raw/master/duplicates/gcc.rb"
      end
      compiler = 'g++-4.6 '
      opt = '-fopenmp'  #'-O3 -DNDEBUG'
    else
      #build osrm with the default gcc 4.2. don't use OpenMP
      compiler = 'g++'
      opt = ''
    end
    
    proto = 'DataStructures/pbf-proto'
    format = "-losmformat.pb.o -lfileformat.pb.o"
    stxxl_prefix = Formula.factory('stxxl').prefix
    boost_prefix = Formula.factory('boost').prefix  
    stxxl = "-I#{stxxl_prefix}/include -L#{stxxl_prefix}/lib -lstxxl "
    boost = "-L#{boost_prefix}/lib -lboost_system-mt -lboost_thread-mt -lboost_regex-mt -lboost_iostreams-mt "
    xml2 = "-I/usr/include/libxml2 -lxml2 "
    bz = "-lbz2 -lz "
    pbf = "-lprotobuf "
    
    system "protoc #{proto}/fileformat.proto -I=#{proto} --cpp_out=#{proto}"
    system "protoc #{proto}/osmformat.proto -I=#{proto} --cpp_out=#{proto}"    
    system "#{compiler} -c #{proto}/fileformat.pb.cc -o #{proto}/fileformat.pb.o #{opt}"
    system "#{compiler} -c #{proto}/osmformat.pb.cc -o #{proto}/osmformat.pb.o #{opt}"
    system "#{compiler} -c extractor.cpp -o osrm-extract #{stxxl+xml2+bz+pbf+format} #{opt}"
    system "#{compiler} -c createHierarchy.cpp -o osrm-prepare #{stxxl+xml2} #{opt}"
    system "#{compiler} -c routed.cpp -o osrm-routed #{stxxl+xml2+boost} #{opt}"
    bin.install ['osrm-extract','osrm-prepare','osrm-routed']
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