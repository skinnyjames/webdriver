require "./spec_helper"

describe Webdriver do
  describe "VERSION" do
    it "is a String" do
      Webdriver::VERSION.should be_a(String)
    end

    it "has a well-formed major, minor and patch version" do
      major, minor, patch = Webdriver::VERSION.split(".")

      major.to_i.should be_a(Int32) # fails if version is, say `X.0.0`
      minor.to_i.should be_a(Int32) # fails if version is, say `1.X.0`
      patch.to_i.should be_a(Int32) # fails if version is, say `1.0.X`
    end
  end

  describe "ELEMENT_KEY" do
    it "is not an String" do
      element_key = Webdriver::ELEMENT_KEY
      element_key.should be_a(String)
      element_key.should_not be_empty
    end
  end
end
