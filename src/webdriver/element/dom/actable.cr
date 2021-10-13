module Webdriver
  module Dom
    module Actable
      def act
        builder = yield Actions::ActionBuilder.new(server)
        server.command.perform_action builder
      end
    end
  end
end
