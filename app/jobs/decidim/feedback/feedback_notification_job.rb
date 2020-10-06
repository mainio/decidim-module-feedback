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
        relevant_recipient_groups(feedback).map { |rg| rg.recipient_emails }.flatten.uniq
      end

      def relevant_recipient_groups(feedback)
        Decidim::Feedback::RecipientGroup.where(organization: feedback.organization).select do |rg|
          if rg.metadata_conditions.blank?
            true
          else
            # Match all the metadata stored in the feedback object with the
            # response group's metadata conditions.
            rg.metadata_conditions.all? do |key, value|
              feedback.metadata[key] == value
            end
          end
        end
      end
    end
  end
end
