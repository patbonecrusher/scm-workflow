require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'highline/import'

describe Scm::Workflow do

  TMP_PATH = "/tmp/"
  BAD_PATH = "/adsdsadasdsa"
  TEST_REPO_PATH = "/tmp/test_git"
  TEST_REPO_PATH_BARE = "/tmp/test_git_bare"

  # -------------------------------------------------------------------------
  # -------------------------------------------------------------------------
  describe "#testInitializeRepo" do
    before(:each) do
      FileUtils.mkpath TEST_REPO_PATH
      @git = Gitit::Git.new(TEST_REPO_PATH)
      @git.repo.init
      @config = @git.config
    end

    it "will successfully encrypt a string" do
      encrypted = "abcd".encrypt
      encrypted.encrypt.should_not eq "abcd"
    end

    it "will successfully decrypt an encrypted string" do
      encrypted = "abcd".encrypt
      encrypted.decrypt.should eq "abcd"
    end

    it "will successfully encrypt and decrypt a string when using a custom key" do
      encrypted = "abcd".encrypt("My custom key")
      encrypted.encrypt.should_not eq "abcd"
      encrypted.decrypt.should_not eq "abcd"
      encrypted.decrypt("My custom key").should eq "abcd"
    end

    after(:each) do
      FileUtils.rm_rf TEST_REPO_PATH
    end

  end

end


