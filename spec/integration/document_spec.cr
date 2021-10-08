require "../spec_helper"

describe Webdriver do
  describe "document behavior" do 
    it "should execute a script" do 
      with_browser("selectors.html") do |browser|
        browser.execute_script("alert('Hello World');")
        browser.alert.should eq("Hello World")
      end
    end

    it "execute script should return data" do
      with_browser("selectors.html") do |browser|
        value = browser.execute_script("return 4 + 4;")
        value.should eq(8)

        obj = browser.execute_script("return { one: 1 }")
        obj["one"].should eq(1)
      end
    end

    it "should get the page source" do 
      html = <<-HTML.gsub(/\n|\s/, "")
      <html>
        <head>
          <title>Basic</title>
        </head>
        <body>
          Hello World
        </body>
      </html>
      HTML
      with_browser("basic.html") do |browser|
        browser.html.gsub(/\n|\s/, "").should eq(html)
      end
    end
  end
end