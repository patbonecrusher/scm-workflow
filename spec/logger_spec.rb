require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Logger do

  # -------------------------------------------------------------------------
  # -------------------------------------------------------------------------
  describe "#testLogSettings" do

    before(:each) do
    end

    it "will initialize successfully" do
      expect{ Scm::Workflow::Utils::LogSettings.new }.to raise_error
      expect{ Scm::Workflow::Utils::LogSettings.instance }.to_not raise_error
      log_settings = Scm::Workflow::Utils::LogSettings.instance
      log_settings.level.should eq Logger::FATAL
      log_settings.output.should eq STDOUT
    end

    after(:each) do
    end

  end

  # -------------------------------------------------------------------------
  # -------------------------------------------------------------------------
  describe "#testLoggingClass" do

    before(:each) do
    end

    it "will initialize successfully" do
      expect{ Scm::Workflow::Utils::Logging.new }.to raise_error
      expect{ Scm::Workflow::Utils::Logging.instance }.to_not raise_error
      logging = Scm::Workflow::Utils::Logging.instance
      logging.logger.level.should eq Logger::FATAL
    end

    after(:each) do
    end

  end

  # -------------------------------------------------------------------------
  # -------------------------------------------------------------------------
  describe "#testLoggingMixIn" do
    include Logging

    before(:each) do
    end

    it "will initialize successfully" do

      log_settings = Scm::Workflow::Utils::LogSettings.instance
      log_settings.level = Logger::INFO
      logger.info("boo")
    end

    after(:each) do
    end

  end

end


