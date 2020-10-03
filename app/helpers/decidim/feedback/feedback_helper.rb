# frozen_string_literal: true

module Decidim
  module Feedback
    module FeedbackHelper
      def feedback_modal(resource, options)
        cell("decidim/feedback/feedback_modal", resource, options).to_s
      end

      def trigger_feedback_modal(resource, options)
        modal = feedback_modal(resource, options)
        modal + javascript_include_tag("decidim/feedback/feedback_modal")
      end
    end
  end
end
