# frozen_string_literal: true

module Decidim
  module Feedback
    # A command to add a new feedback.
    class SendFeedback < Decidim::Command
      # Public: Initializes the command.
      #
      # form - The feedback form.
      # user - The user sending the feedback.
      def initialize(form, user)
        @form = form
        @user = user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the handler wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        create_feedback!
        send_notification

        broadcast(:ok, feedback)
      end

      private

      attr_reader :feedback, :form, :user

      def create_feedback!
        @feedback = Decidim::Feedback::Feedback.create!(
          rating: form.rating,
          body: form.try(:body) || "",
          contact_request: form.try(:contact_request) || false,
          metadata: form.metadata,
          feedbackable: form.feedbackable,
          organization: form.current_organization,
          user: user
        )
      end

      def send_notification
        Decidim::Feedback::FeedbackNotificationJob.perform_later(@feedback)
      end
    end
  end
end
