require 'helper'

describe Mercurial::Command do
  
  before do
    @repository = Mercurial::Repository.open(Fixtures.test_repo)
  end
  
  it "should execute shell commands" do
    output = Mercurial::Command.new("cd #{ @repository.path } && hg log").execute
    (output.size > 100).must_equal true
  end
  
  it "should translate shell errors to ruby exceptions" do
    lambda{
      Mercurial::Command.new("cd #{ @repository.path } && hg shikaka").execute
    }.must_raise Mercurial::CommandError
  end
  
  it "should execute commands with timeout" do
    Mercurial.configuration.stubs(:shell_timeout).returns(1)
    lambda{
      Mercurial::Command.new("sleep 5").execute
    }.must_raise Timeout::Error
  end
  
  it "should generate cache key for every command" do
    key = Mercurial::Command.new("cd #{ @repository.path } && hg log", :repository => @repository).send(:cache_key)
    key.must_be_kind_of String
    (key.size > 10).must_equal true
    
    key2 = Mercurial::Command.new("cd #{ @repository.path } && hg log", :repository => @repository).send(:cache_key)
    key.must_equal key2
    
    key3 = Mercurial::Command.new("cd #{ @repository.path } && hg log -v", :repository => @repository).send(:cache_key)
    key3.wont_equal key2
    key3.wont_equal key
  end
  
end