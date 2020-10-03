# frozen_string_literal: true

module Decidim
  module Feedback
    # A form object to be used when users want to send feedback.
    class FeedbackForm < Decidim::Form
      mimic :feedback

      attribute :body, String
      attribute :rating, Integer
      attribute :contact_request, Boolean
      attribute :metadata, Hash
      attribute :feedbackable_gid, String

      validates :body, :rating, presence: true

      def feedbackable
        @feedbackable ||= GlobalID::Locator.locate_signed feedbackable_gid
      end
    end
  end
end
