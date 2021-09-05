require "./element"
module Webdriver
  class TimeoutException < Exception; end
  module Wait
    def self.wait_until(interval : Float, timeout : Int32, object : Object = nil, &block)
      time = Time.local
      while (Time.local - time).seconds < timeout
        begin
          result = yield(object)
          return result if !!result
        rescue ex : Exception
          puts ex
          sleep interval
        end
      end
      raise TimeoutException.new("timed out after #{timeout}")
    end
  end
end