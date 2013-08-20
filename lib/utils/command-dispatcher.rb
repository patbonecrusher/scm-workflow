module Scm 
  module Workflow
    module Utils
    end
  end
end

module Scm::Workflow::Utils

  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------
  class CommandDispatcher
  
    EX_NOCMD="No command specified"
    EX_INVALCMD="is not a valid command"
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def initialize(rootScriptAbsLocation, rootScriptName)
      @rootScriptAbsLocation = rootScriptAbsLocation
      @rootScriptName = rootScriptName
      @commandPrefix = rootScriptAbsLocation + '/' + rootScriptName + '-';
    end   
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def usage()
      Dir.glob(@commandPrefix + '*').each do |f|
        tmp=f.slice(@commandPrefix.size, f.size)
        invalid=tmp.include? "-"
        if !invalid
          help = `#{f} --usage`
          command = File.basename(f).gsub!( "-", " " )
          $stdout.puts command.ljust(25)  + " : " + help 
        end 
      end
    end

    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def dispatchCommand(cmd, *arguments)
    
      raise ArgumentError.new(EX_NOCMD) if cmd == nil
      raise ArgumentError.new("#{cmd} " + EX_INVALCMD) unless isValid?(cmd)
    
      exec(@commandPrefix + cmd, *arguments)
    end

    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    def isValid?(command)
      return false if (!File.exists?(@commandPrefix + command))
      return true
    end

  end
  
end
