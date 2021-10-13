require "../actions"
module Webdriver
  module Commands
    module Actions
      def perform_action(action_builder : Webdriver::Actions::ActionBuilder)
        make_post_request "actions", action_builder
      end
    end
  end
end
