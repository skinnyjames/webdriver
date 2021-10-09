module Webdriver
  class ElementNotFoundException < Exception; end
  class InvalidSelectorException < Exception; end 
  class InvalidArgumentException < Exception; end
  class UnexpectedAlertException < Exception; end
  class UnknownException < Exception; end
  class SessionNotCreatedException < Exception; end
  class StaleElementReferenceException < Exception; end
  class ElementClickInterceptedException < Exception; end
end

