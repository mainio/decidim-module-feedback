# frozen_string_literal: true

module Decidim
  module Feedback
    # A custom mailer for sending notifications about feedback to specific
    # recipients when feedback has been received.
    class FeedbackMailer < Decidim::ApplicationMailer
      helper Decidim::ResourceHelper

      def feedback_received(feedback, recipient_email)
        i18n_scope = "decidim.feedback.feedback_mailer.feedback_received"

        @sender_name = feedback.user&.name
        @sender_email = feedback.user&.email
        @feedback_body = feedback.body
        @feedback_rating = feedback.rating
        @metadata = feedback.metadata
        @organization = feedback.organization

        wants_contact = feedback.contact_request? ? "yes" : "no"
        @contact_answer = I18n.t(
          "contact_request_answer_#{wants_contact}",
          scope: i18n_scope
        )

        @resource = feedback.feedbackable
        if @resource
          @resource_name = @resource.class.model_name.human(count: 2)
          @resource_link = Decidim::ResourceLocatorPresenter.new(@resource).url
        end

        subject = I18n.t("subject", organization_name: @organization.name, scope: i18n_scope)

        I18n.with_locale(@organization.default_locale) do
          mail(
            to: recipient_email,
            reply_to: @sender_email.blank? ? nil : @sender_email,
            subject: subject
          )
        end
      end
    end
  end
end
