# frozen_string_literal: true

module Decidim
  module Feedback
    # This cell renders the button to add the given resource to feedback.
    class FeedbackModalCell < Decidim::ViewModel
      include LayoutHelper
      include Decidim::SanitizeHelper
      include Decidim::ResourceHelper

      def show
        return unless current_user

        render
      end

      private

      def modal_id
        options[:modal_id] || "feedback-modal"
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

      def rating_content(rating)
        content_tag(:span, class: "rating-value-star") do
          render :star_icon
        end
      end

      def title
        options[:title] || I18n.t("decidim.feedback.feedback_modal.title")
      end

      def feedback_max_length
        1000
      end

      def metadata
        options[:metadata] || {}
      end
    end
  end
end
