require "../spec_helper"

describe Webdriver do
  describe "navigation" do 
    it "should perform basic navigation" do 
      with_browser("windows/window_one.html") do |browser|
        browser.goto "#{SERVER_URL}/windows/window_two.html"
        browser.url.should eq("#{SERVER_URL}/windows/window_two.html")
        browser.back
        browser.title.should eq("Window 1")
        browser.forward
        browser.title.should eq("Window 2")
        browser.refresh
        browser.title.should eq("Window 2")
      end
    end
  end
end