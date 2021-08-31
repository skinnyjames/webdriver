require "../spec_helper"

describe SeleniumWebdriver do
  describe "error handling behavior" do
    it "throws error when element can't be located" do
      with_browser("html_patterns.html") do |browser|
        expect_raises(SeleniumWebdriver::ElementNotFoundException) do 
          puts browser.header(index: 1).text_field(id: "text_field").text
        end
      end
    end
  end
end