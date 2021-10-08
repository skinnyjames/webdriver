require "../spec_helper"

describe Webdriver do 
  describe "windows" do 
    it "should handle windows/tabs" do 
      with_browser("basic.html") do |browser|
        first_tab = browser.windows[0]
        second_tab = browser.windows.new
        browser.use(second_tab)
        browser.goto "https://www.google.com"
        third_tab = browser.windows.new
        browser.use(third_tab)
        browser.goto "https://www.yahoo.com"
        browser.url.should eq "https://www.yahoo.com/"
        browser.close(third_tab)
        browser.url.should eq "https://www.google.com/"
        browser.use(first_tab)
        browser.title.should eq "Basic"
        browser.close(first_tab)
        browser.url.should eq "https://www.google.com/"
      end
    end
  end
end