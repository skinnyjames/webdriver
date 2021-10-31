require "../spec_helper"

describe Webdriver do
  describe "check for presence" do 
    it "locate correctly after time passes" do 
      with_browser("async/present.html") do |browser|
        element = browser.h1(visible_text: /Present/)
        element.exists?.should eq(false)
        sleep 2
        element.exists?.should eq(true)
        element.present?.should eq(true)
      end
    end

    it "should wait until present" do 
      with_browser("async/present.html") do |browser|
        browser.h1.wait_until(&.present?).text.should eq("Present")
      end
    end
  end  
end