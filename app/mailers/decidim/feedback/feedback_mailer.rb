# frozen_string_literal: true

module Decidim
  module Feedback
    # A custom mailer for sending notifications about feedback to specific
    # recipients when feedback has been received.
    class FeedbackMailer < Decidim::ApplicationMailer
      helper Decidim::ResourceHelper

      helper_method :cell

      def feedback_received(feedback, recipient_email)
        i18n_scope = "decidim.feedback.feedback_mailer.feedback_received"

        @feedback = feedback
        @organization = feedback.organization
        sender_email = feedback.contact_request ? feedback.user&.email : nil

        I18n.with_locale(@organization.default_locale) do
          subject = I18n.t("subject", organization_name: @organization.name, scope: i18n_scope)
          mail(
            to: recipient_email,
            reply_to: sender_email.presence,
            subject: subject
          )
        end
      end

      private

      def cell(template, model, options)
        ::Decidim::ViewModel.cell(
          template,
          model,
          options.merge(
            organization: @organization,
            context: { controller: self }
          )
        )
      end
    end
  end
end
