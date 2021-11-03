require "../spec_helper"

describe Webdriver do 
  describe "windows" do 
    it "should handle windows/tabs" do 
      with_browser("windows/window_one.html") do |browser|
        first_tab = browser.windows[0]
        second_tab = browser.windows.new
        browser.use(second_tab)
        browser.goto "#{SERVER_URL}/windows/window_two.html"
        third_tab = browser.windows.new
        browser.use(third_tab)
        browser.goto "#{SERVER_URL}/windows/window_three.html"
        browser.title.should eq "Window 3"
        browser.close(third_tab)
        browser.title.should eq "Window 2"
        browser.use(first_tab)
        browser.title.should eq "Window 1"
        browser.close(first_tab)
        browser.title.should eq "Window 2"
      end
    end

    it "should handle frames" do 
      with_browser("windows/frame.html") do |browser|
        browser.div(id: "window-2-element").exists?.should eq(false)
        frame = browser.iframe(id: "window-2")
        browser.use(frame)
        browser.div(id: "window-2-element").exists?.should eq(true)
        browser.switch_to_parent_frame
        browser.div(id: "window-2-element").exists?.should eq(false)
      end
    end
  end
end