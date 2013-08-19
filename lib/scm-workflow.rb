require "bundler/setup"
require "scm-workflow"
require "utils/logging"

require "kruptos"
require "base64"
require "ext/string"

require "gitit"
require "workflow"

require "scm-workflow/configuration"
Dir[File.dirname(__FILE__) + "/scm-workflow/workflow-*.rb"].each do |file|
  require file
end

module Scm
  module Workflow
    # Your code goes here...
  end
end
