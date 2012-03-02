module Mercurial
  
  #
  # The class represents Mercurial branch. Obtained by running an +hg branches+ command.
  #
  # The class represents Branch object itself, {Mercurial::BranchFactory BranchFactory} is responsible
  # for assembling instances of Branch. For the list of all possible branch-related operations please 
  # look documentation for {Mercurial::BranchFactory BranchFactory}.
  #
  # Read more about Mercurial branches:
  #
  # http://mercurial.selenic.com/wiki/Branch
  #
  class Branch
   
    # Instance of {Mercurial::Repository Repository}.
    attr_reader :repository
    
    # Name of the branch.
    attr_reader :name
    
    # State of the branch: closed or active.
    attr_reader :status
    
    # ID of a commit associated with the branch. 40-chars long SHA1 hash.
    attr_reader :hash_id
    
    def initialize(repository, name, options={})
      @repository    = repository
      @name          = name
      @status        = options[:status] == 'closed' ? 'closed' : 'active'
      @hash_id       = options[:commit]
    end

    def commit
      repository.commits.by_hash_id(hash_id)
    end
    
    def active?
      status == 'active'
    end
    
    def closed?
      status == 'closed'
    end
    
  end
  
end