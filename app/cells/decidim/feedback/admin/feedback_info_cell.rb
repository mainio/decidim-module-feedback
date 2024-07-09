# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      # This cell renders the feedback info modal at the admin panel.
      class FeedbackInfoCell < Decidim::ViewModel
        private

        def modal_id
          options[:modal_id] || "feedbackInfoModal"
        end

        def show_email_link?
          options[:show_email_link]
        end

        def show_contact?
          options[:show_contact]
        end
      end
    end
  end
end
