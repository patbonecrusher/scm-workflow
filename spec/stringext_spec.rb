require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe String do

  # -------------------------------------------------------------------------
  # -------------------------------------------------------------------------
  describe "#testStringEncrypt" do

    before(:each) do
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
    end

  end

end

