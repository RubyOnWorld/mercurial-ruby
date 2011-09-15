require 'helper'

describe Mercurial::DiffFactory do
  
  before do
    @repository = Mercurial::Repository.open(Fixtures.test_repo)
  end
  
  it "should find diffs for commit" do
    commit = @repository.commits.by_hash_id('54d96f4b1a26')
    diffs = @repository.diffs.for_commit(commit)
    diffs.size.must_equal 6
    diffs.map(&:file_name).sort.must_equal ['LICENSE4.txt', 'README.markup', 'Rakefile', 'Rakefile2', 'Rakefile3', 'superman.txt']
  end
  
  it "should work for files with dots in their names" do
    commit = @repository.commits.by_hash_id('b66320fa72aa')
    diffs = commit.diffs
    diffs.size.must_equal 1
    diffs.first.file_name.must_equal '.DotFile'
  end
  
  it "should handle binary files properly" do
    commit = @repository.commits.by_hash_id('c2b3e46b986e')
    commit.diffs.size.must_equal 1
    diff = commit.diffs.first
    diff.must_be_kind_of Mercurial::Diff
    diff.file_name.must_equal 'goose.png'
    diff.body.must_equal 'Binary files differ'
    diff.binary?.must_equal true
  end
  
  it "should handle empty files properly" do
    commit = @repository.commits.by_hash_id('8173f122b0d0')
    commit.diffs.size.must_equal 0
  end
  
  it "should find diffs for path" do
    diff = @repository.diffs.for_path('diff-test.rb', '57a6efe309bf', '9f76ea916c51')
    diff.must_be_kind_of Mercurial::Diff
    diff.hash_a.must_equal '57a6efe309bf'
    diff.hash_b.must_equal'9f76ea916c51'
    diff.file_a.must_equal 'diff-test.rb'
    diff.file_b.must_equal 'diff-test.rb'
    diff.body.must_equal diff_sample
  end
  
private

  def diff_sample
    %Q[--- a/diff-test.rb	Thu Sep 15 23:43:02 2011 +0800
+++ b/diff-test.rb	Thu Sep 15 23:43:52 2011 +0800
@@ -5,19 +5,17 @@
 
   before_filter :repository_detected?, :except => :index
   before_filter :welcome_screen,       :only => :index
-  before_filter :prepare_to_show,      :only => [:show, :differences, :message]
   before_filter :setup_page,           :only => [:index, :repository]
 
   caches_action :message, :differences
 
+  helper_method :current_branch
   helper_method :repository_scope?
-  helper_method :quick_changeset
   helper_method :changesets_changes_limit
-  helper_method :current_branch
   helper_method :diff_taking_too_much_time_msg
 
   def repository
-    if current_repository.import_in_progress?
+    unless current_repository.import_in_progress?
       return render(:template => "changesets/import_in_progress")
     end
     @changesets         = find_changesets_for_current_scope
]
  end
  
end