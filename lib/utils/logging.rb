module Scm
  module Workflow
    module Utils
    end
  end
end

require 'singleton'
require 'logger'

module Scm::Workflow::Utils
  class LogSettings
    include Singleton
    attr_accessor :level
    attr_accessor :output
    def initialize
        @level = Logger::FATAL
        @output = STDOUT
    end
  end

  class Logging
    include Singleton

    attr_reader :logger
    def initialize
      logsettings = Scm::Workflow::Utils::LogSettings.instance
      @logger = Logger.new(logsettings.output)
      @logger.level = logsettings.level
    end
  end
end

module Logging

  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------
  def logger
    @logger ||= Logging.logger_for(self.class.name)
  end

  # Use a hash class-ivar to cache a unique Logger per class:
  @loggers = {}

  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------
  class << self

    def logger_for(classname)
      @loggers[classname] ||= configure_logger_for(classname)
    end

    def configure_logger_for(classname)
      logsettings = Scm::Workflow::Utils::LogSettings.instance
      logger = Logger.new(logsettings.output)
      logger.progname = classname
      logger.level = logsettings.level
      logger
    end
  end

end
