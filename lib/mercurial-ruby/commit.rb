module Mercurial
  
  class Commit
    include Mercurial::Helper
    
    attr_reader :repository, :hash_id, :author, :author_email,
                :date, :message, :changed_files,
                :branches_names, :tags_names, :parents_ids
    
    alias :id :hash_id
    
    def initialize(repository, opts={})
      @repository     = repository
      @hash_id        = opts[:hash_id]
      @author         = opts[:author]
      @author_email   = opts[:author_email]
      @date           = Time.iso8601(opts[:date])
      @message        = opts[:message]
      @changed_files  = files_to_array(opts[:changed_files])
      @branches_names = branches_or_tags_to_array(opts[:branches_names])
      @tags_names     = branches_or_tags_to_array(opts[:tags_names])
      @parents_ids    = parents_to_array(opts[:parents])
    end
    
    def merge?
      parents.size > 1
    end
    
    def blank?
      hash_id == '0'*40
    end
    
    def diffs
      repository.diffs.for_commit(self)
    end
    
    def parents
      repository.commits.by_hash_ids(parents_ids)
    end
    
    def parent_id
      parents_ids.first
    end
    
    def exist_in_branches
      repository.branches.for_commit(hash_id)
    end
    
    def to_hash
      {
        'id'       => hash_id,
        'parents'  => parents_ids.map { |p| { 'id' => p.id } },
        'branches' => branches_names,
        'tags'     => tags_names,
        'message'  => message,
        'date'     => date,
        'author'   => {
          'name'  => author,
          'email' => author_email
        }
      }
    end
    
  protected
  
    def files_to_array(array)
      [].tap do |returning|
        array.each do |files|
          if files
            files.split(';').map do |file_with_mode|
              returning << Mercurial::ChangedFileFactory.new_from_hg(file_with_mode)
            end
          end
        end
        
        remove_files_duplicates(returning)
      end
    end
    
    def remove_files_duplicates(files)
      Mercurial::ChangedFileFactory.delete_hg_artefacts(files)
    end
    
    def branches_or_tags_to_array(branches_str)
      string_to_array(branches_str) do |returning|
        returning << branches_str
      end
    end
    
    def parents_to_array(string)
      string_to_array(string) do |returning|
        string.split(' ').map do |hg_hash|
          returning << hg_hash_to_hash_id(hg_hash)
        end
      end
    end
    
    def string_to_array(string, &block)
      if string && !string.empty?
        [].tap do |returning|
          block.call(returning)
        end
      else
        []
      end
    end
    
    def hg_hash_to_hash_id(hg_hash)
      hg_hash.split(':').last
    end
    
  end
  
end