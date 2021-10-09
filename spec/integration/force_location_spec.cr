describe Webdriver do 
  describe "Force location" do 
    it "should handle stale elements" do 
      with_browser("duplicate/twin.html") do |browser|
        header = browser.header
        header.text.should eq("Header text")
        browser.goto "#{SERVER_URL}/duplicate/twin_two.html"
        expect_raises(Webdriver::Command::StaleElementReferenceException) do 
          header.text
        end
        header.text(force: true).should eq("Nested header text")
      end
    end

    it "should handle stale elements from a collection" do
      with_browser("duplicate/twin.html") do |browser|
        second_li = browser.lis[1]
        second_li.text.should eq("First li text")
        browser.goto "#{SERVER_URL}/duplicate/twin_two.html"
        expect_raises(Webdriver::Command::StaleElementReferenceException) do 
          second_li.text
        end
        second_li.text(force: true).should eq("Second li text")
      end
    end
  end
end