# frozen_string_literal: true

module Decidim
  module Feedback
    module FeedbackHelper
      def feedback_modal(resource, options)
        cell("decidim/feedback/feedback_modal", resource, options).to_s
      end

      def trigger_feedback_modal(resource, options)
        modal = feedback_modal(resource, options)
        javascript_tag = append_javascript_pack_tag("decidim_feedback") || ""
        modal + javascript_tag
      end
    end
  end
end
