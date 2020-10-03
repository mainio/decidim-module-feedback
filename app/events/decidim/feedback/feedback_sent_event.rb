# frozen-string_literal: true

module Decidim
  module Feedback
    class FeedbackSentEvent < Decidim::Events::SimpleEvent
      i18n_attributes :organization_name

      def resource_text
        [
          resource.body,
          t("decidim.events.feedback.feedback_sent.contact_request", answer: contact_request_answer)
        ].join("<br><br>")
      end

      def contact_request_answer
        if resource.contact_request
          t("decidim.events.feedback.feedback_sent.contact_request_answer_yes")
        else
          t("decidim.events.feedback.feedback_sent.contact_request_answer_no")
        end
      end

      def organization_name
        resource.organization.name
      end
    end
  end
end
