# frozen_string_literal: true

module Decidim
  module Feedback
    # This cell renders the inline buttons to give a quick feedback on the
    # given resource.
    class FeedbackInlineCell < Decidim::ViewModel
      include LayoutHelper
      include Decidim::SanitizeHelper
      include Decidim::ResourceHelper

      # TODO

      private

      def content_id
        options[:content_id] || "feedback-inline"
      end

      def decidim_feedback
        Decidim::Feedback::Engine.routes.url_helpers
      end

      def feedback_form
        Decidim::Feedback::FeedbackForm.new(
          body: "",
          rating: 0,
          contact_request: false,
          metadata: {},
          feedbackable_gid: model ? model.to_sgid.to_s : ""
        )
      end
    end
  end
end
