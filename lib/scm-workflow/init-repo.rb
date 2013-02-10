require "bundler/setup"
Bundler.require(:default)

module ScmWorkflow
end

module ScmWorkflow

  class InitRepoWorkflow
    include Workflow
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def initialize(repo, &block)
      @repo = repo
      @configData = ScmWorkflow::Configuration.new
      @callback = block
    end
  
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    workflow do
      state :start do
        event :validate, :transitions_to => :validating
      end
      state :validating do
        event :retrieveInfo, :transitions_to => :retrieving
        event :terminate, :transitions_to => :terminated
      end
      state :retrieving do
        event :inquireUser, :transitions_to => :querying
      end
      state :querying do
        event :cancel, :transitions_to => :terminated
        event :persistInfo, :transitions_to => :persisting
      end
      state :persisting do
        event :terminate, :transitions_to => :terminated
      end
      state :terminated
    end

    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def on_validating_entry(new_state, event, *args)
      puts "E: Init worflow ready to go"
      @repoValid = @repo.isAValidRepo?
    end
    
    def on_validating_exit(new_state, event, *args)
      puts "X: Init worflow done"
    end
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def on_retrieving_entry(new_state, event, *args)
      puts "E: Retrieving pharos configuration info"
      
      @repo.readConfiguration(@configData)

    end

    def on_retrieving_exit(new_state, event, *args)
      puts "X: Retrieving pharos configuration info done"
    end
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def on_querying_entry(new_state, event, *args)
      puts "E: Querying pharos configuration info"
      @callback.call(@configData)
    end

    def on_querying_exit(new_state, event, *args)
      puts "X: Querying pharos configuration info done"
    end
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def on_persisting_entry(new_state, event, *args)
      puts "E: Persisting pharos configuration info"
      
      @configData.instance_variables.each do |v|
        globalEntry = @configData.instance_variable_get(v)
        
        entryTitle = globalEntry.class.name.split('::').last.downcase
        globalEntry.instance_variables.each do |sv|
          begin
            entry = globalEntry.instance_variable_get(sv)
            @repo.setConfigValue("pharos.#{entryTitle}.#{sv[1..-1]}", entry.value, entry.hideinput)
          rescue => exception
          end
        end
      end

    end

    def on_persisting_exit(new_state, event, *args)
      puts "X: Persisting pharos configuration info done"
    end
    
    def repoIsValid?
      return @repoValid
    end
    
  end
  
  class InitializeRepo
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def initialize(repo)
      @repo = repo
    end   

    def execute(&block)
      callback = block
      @initWorkflow = InitRepoWorkflow.new(@repo, &callback)
      @initWorkflow.validate!
      
      if @initWorkflow.repoIsValid?
        @initWorkflow.retrieveInfo!
        @initWorkflow.inquireUser!
        @initWorkflow.persistInfo!
        @initWorkflow.terminate!
        @success = true
      else
        @initWorkflow.terminate!
        @success = false
      end
    end

    def wasSuccessfull? 
      return @success
    end
   
  end

end
