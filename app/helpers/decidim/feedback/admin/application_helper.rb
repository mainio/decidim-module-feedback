# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      # Custom helpers, scoped to the feedback admin engine.
      #
      module ApplicationHelper
        include Decidim::Messaging::ConversationHelper

        def tabs_id_for_recipient(recipient)
          "recipient_group_recipient_#{recipient.to_param}"
        end

        def tabs_id_for_condition(condition)
          "recipient_group_condition_#{condition.to_param}"
        end
      end
    end
  end
end
