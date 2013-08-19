
module Scm
  module Workflow
  end
end

module Scm::Workflow

  class InitRepoWorkflow
    include Logging
    include Workflow
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def initialize(repo, configuration, &block)
      @repo = repo
      @config = repo.config
      @configuration = configuration
      @callback = block
      logger.info("asdasdsa")
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
      logger.info("E: Init worflow ready to go")
      @repoValid = @repo.repo.valid?
    end
    
    def on_validating_exit(new_state, event, *args)
      logger.info("X: Init worflow done")
    end
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def on_retrieving_entry(new_state, event, *args)
      logger.info("E: Retrieving configuration info")
      
      @configuration.each { |c| 
        entryTitle = c.class.name.split('::').last.downcase
        c.instance_variables.each do |sv|
          begin
            entry = c.instance_variable_get(sv)
            entry.value = @config.getValue("scm-workflow.#{entryTitle}.#{sv[1..-1]}")
          rescue => exception
            # That's ok, a missing value is ok.
          end
        end
      }

    end

    def on_retrieving_exit(new_state, event, *args)
      logger.info("X: Retrieving configuration info done")
    end
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def on_querying_entry(new_state, event, *args)
      logger.info("E: Querying configuration info")
      @callback.call(@configuration)
    end

    def on_querying_exit(new_state, event, *args)
      logger.info("X: Querying configuration info done")
    end
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def on_persisting_entry(new_state, event, *args)
      logger.info("E: Persisting configuration info")
      
      @configuration.each { |c| 
        globalEntry = c
        
        entryTitle = c.class.name.split('::').last.downcase
        c.instance_variables.each do |sv|
          begin
            entry = c.instance_variable_get(sv)
            value = entry.value unless entry.hideinput
            value = entry.value.encrypt if entry.hideinput

            @config.setValue("scm-workflow.#{entryTitle}.#{sv[1..-1]}", value)
          rescue => exception
            logger.error(exception.to_s)
          end
        end
      }

    end

    def on_persisting_exit(new_state, event, *args)
      logger.info("X: Persisting configuration info done")
    end
    
    def repoIsValid?
      return @repoValid
    end
    
  end
  
  class InitializeRepo
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def initialize(repo, configuration)
      @repo = repo
      @configuration = configuration

      raise "Invalid repo specified" if @repo.nil?
      raise "Invalid configuration specified" if @configuration.nil?
    end   

    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def execute(&block)
      callback = block
      @initWorkflow = InitRepoWorkflow.new(@repo, @configuration, &callback)
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
