require 'helper'

describe Mercurial::Node do
  
  before do
    @repository = Mercurial::Repository.open(Fixtures.test_repo)
  end
  
  it "should be considered directory when ends with a slash" do
    node = @repository.nodes.find('new-directory/subdirectory/', 'a8b39838302f')
    node.file?.must_equal false
    node.directory?.must_equal true
  end
  
  it "should be considered file when doesn't end with a slash" do
    node = @repository.nodes.find('new-directory/something.csv', 'a8b39838302f')
    node.file?.must_equal true
    node.directory?.must_equal false
  end
  
  it "should show node contents" do
    node = @repository.nodes.find('new-directory/something.csv', 'a8b39838302f')
    node.contents.strip.must_equal 'Here will be CSV.'
    
    node = @repository.nodes.find('new-directory/something.csv', '291a498f04e9')
    node.contents.strip.must_equal 'Here will be some new kind of CSV.'
  end
  
end