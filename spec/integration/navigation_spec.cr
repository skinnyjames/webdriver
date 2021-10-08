require "../spec_helper"

describe Webdriver do
  describe "navigation" do 
    it "should perform basic navigation" do 
      with_browser("basic.html") do |browser|
        browser.goto "https://www.google.com" 
        browser.url.should eq("https://www.google.com/")
        browser.back
        browser.title.should eq("Basic")
        browser.forward
        browser.url.should eq("https://www.google.com/")
        browser.refresh
        browser.url.should eq("https://www.google.com/")
      end
    end
  end
end