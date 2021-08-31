require "../spec_helper"

describe Webdriver do
  describe "error handling behavior" do
    it "throws error when element can't be located" do
      with_browser("html_patterns.html") do |browser|
        expect_raises(Webdriver::ElementNotFoundException) do 
          browser.header(index: 1).text_field(id: "text_field").text
        end
      end
    end
  end
end