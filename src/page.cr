require "./page/page_object"

module Webdriver
  module PageFactory
    def with_browser(url : String, browser_type : Symbol = :chrome, **opts, &)
      browser = Webdriver::Browser.start(browser_type, **opts)
      
      begin
        browser.goto(url)
        yield browser
      ensure
        browser.try(&.quit)
      end
    end

    def on(page_class : PageObject.class, browser : Webdriver::Browser, &)
      page = page_class.new(browser)    
      yield page  
    end
  end
end