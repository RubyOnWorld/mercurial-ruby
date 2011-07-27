require 'helper'

describe Mercurial::CommitFactory do
  
  before do
    @repository = Mercurial::Repository.open(Fixtures.test_repo)
  end
  
  it "should find commit by hash" do
    commit = @repository.commits.by_hash_id('bc729b15e2b5')
    commit.author.must_equal 'Ilya Sabanin'
    commit.author_email.must_equal 'ilya.sabanin@gmail.com'
    commit.hash_id.must_equal 'bc729b15e2b556065dd4f32c161f54be5dd92776'
    commit.message.must_equal 'Directory added'
  end
  
  it "should not find inexistent commit by hash" do
    @repository.commits.by_hash_id('dfio9sdf78sdfh').must_equal nil
  end
  
  it "should find all commits" do
    commits = @repository.commits.all
    (commits.size > 5).must_equal true
  end
  
  it "should find commits by branch" do
    commits = @repository.commits.by_branch("new-branch")
    commits.size.must_equal 3
    commits.map(&:hash_id).sort.must_equal ["63e18640e83af60196334f16cc31f4f99c419918", "63f70b2314ede1e12813cae87f6f303ee8d5c09a", "bc729b15e2b556065dd4f32c161f54be5dd92776"].sort
  end
  
  it "should not find commits for inexistent branch" do
    @repository.commits.by_branch("shikaka").must_equal []
  end
  
  it "should find tip commit" do
    tip = @repository.commits.tip
    tip.must_be_kind_of Mercurial::Commit
  end
  
end