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
      ['--local', "Fetch from local repo",
       '--emil', "Fetch from https://raw.github.com/emiltin"],
    ]
  end

  def install  
    #the stxxl formula isn't yet accepted into the main brew repo, so we install from an alternative repo
    unless Formula.factory('libstxxl').installed?
      system "brew install https://raw.github.com/emiltin/homebrew/master/Library/Formula/libstxxl.rb"
    end
    
    system "rake"   #rake will use the Rakefile to build
    bin.install ['build/osrm-extract','build/osrm-prepare','build/osrm-routed']
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