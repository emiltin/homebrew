require 'formula'

class Osrm < Formula
  #url 'http://downloads.sourceforge.net/project/routed/osrm_0.2.tar.gz'
  #md5 '4e2696e0eab9b90ca17fae183061e766'
  if ARGV.include? '--local'
    head '/Users/emil/code/Project-OSRM/.git', :using => :git, :branch => :sandbox
  elsif ARGV.include? '--mac'
    head 'https://github.com/emiltin/Project-OSRM', :using => :git, :branch => :sandbox
  else
    head 'https://github.com/DennisOSRM/Project-OSRM', :using => :git
  end
  homepage 'http://project-osrm.org'
  
  depends_on 'protobuf'
  depends_on 'boost'
  depends_on 'boost-jam'
  depends_on 'libzip'
  depends_on 'libstxxl'

  def options
    [
      ['--local', "Fetch from local repo",
       '--mac', "Fetch from https://raw.github.com/emiltin"],
    ]
  end

  def install  
    system "scons"
    bin.install ['sandbox/osrm-extract','sandbox/osrm-prepare','sandbox/osrm-routed']
  end

  def test
    #system "cucumber"
  end
end