module Scm
  module Workflow
  end
end

module Scm::Workflow

  class ConfigElement
    attr_reader :info;
    attr_accessor :value;
    attr_reader :hideinput; 
    
    def initialize (info, hideinput, default)
      @info = info;
      @hideinput = hideinput;
      @value = default;
    end
  end

  class Flow
    attr_accessor :develop;
    attr_accessor :feature;
    
    def initialize
      @develop = ConfigElement.new("Develop branch name", false, "develop")
      @feature = ConfigElement.new("Feature branch name", false, "feature")
    end

    def to_s
      return "Specify branch related information: "
    end
    
  end

  class CodeCollab
    attr_accessor :app_exec_path;
    attr_accessor :username;
    attr_accessor :serverurl;
    attr_accessor :reviewers;
    attr_accessor :observers;

    def initialize
      @execpath = ConfigElement.new("Path to code collab executable", false, "/Applications/ccollab_client/ccollab")
      @serverurl = ConfigElement.new("Code collab server url", false, "https://development-us:8443")
      @username = ConfigElement.new("Code collab username", false, "")
      @reviewers = ConfigElement.new("List of reviewers id, coma separated", false, "")
      @observers = ConfigElement.new("List of observers id, coma separated", false, "")
    end
    
    def to_s
      return "Specify code collab related information: "
    end

  end

  
  class Rally
    attr_accessor :username;
    attr_accessor :password;
    attr_accessor :serverurl;
    attr_accessor :workspace;
    attr_accessor :project;

    def initialize
      @serverurl = ConfigElement.new("Rally server url", false, "https://rally1.rallydev.com/")
      @username = ConfigElement.new("Rally username", false, "")
      @password = ConfigElement.new("Rally password", true, "")
      @workspace = ConfigElement.new("Rally workspace", false, "")
      @project = ConfigElement.new("Rally project", false, "")
    end

    def to_s
      return "Specify Rallydev related information: "
    end
  
  end

end
