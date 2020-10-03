# frozen_string_literal: true

module Decidim
  module Feedback
    class FeedbackNotificationJob < ApplicationJob
      queue_as :events

      def perform(feedback)
        recipient_emails(feedback).each do |email|
          Decidim::Feedback::FeedbackMailer.feedback_received(feedback, email).deliver_later
        end
      end

      private

      def recipient_emails(feedback)
        (static_emails + admin_emails(feedback)).uniq
      end

      def static_emails
        return [] unless Decidim::Feedback.notify_emails.is_a?(Array)

        Decidim::Feedback.notify_emails
      end

      def admin_emails(feedback)
        return [] unless Decidim::Feedback.notify_admins

        Decidim::User.where(organization: feedback.organization, admin: true).pluck(:email)
      end
    end
  end
end
