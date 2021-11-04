require "./element"
module Webdriver
  class TimeoutException < Exception; end
  module Wait

    def self.wait_while(interval : Float, timeout : Int32, object : Object = nil, &block) 
      wait(interval: interval, timeout: timeout, object: object, negate: true) do |object|
        yield object
      end
    end

    def self.wait_until(interval : Float, timeout : Int32, object : Object = nil, &block)
      wait(interval: interval, timeout: timeout, object: object, negate: false) do |object|
        yield object
      end
    end

    protected def self.wait(interval : Float, timeout : Int32, object : Object = nil, negate : Bool = false, &block)
      time = Time.local
      while (Time.local - time).seconds < timeout
        begin
          result = yield(object)
          return object if (negate ? !result : !!result)
        rescue ex : Exception
          Log.info { ex }
          if negate 
            return object
          else
            sleep interval
          end
        end
      end
      raise TimeoutException.new("timed out after #{timeout}")
    end
  end
end