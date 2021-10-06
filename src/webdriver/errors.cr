module Webdriver
  class ElementNotFoundException < Exception; end
  class InvalidSelectorException < Exception; end 
  class InvalidArgumentException < Exception; end
  class UnexpectedAlertException < Exception; end
  class UnknownException < Exception; end
end