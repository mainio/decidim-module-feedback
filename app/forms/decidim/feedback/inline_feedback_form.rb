# frozen_string_literal: true

module Decidim
  module Feedback
    # A form object to be used when users want to send feedback through the
    # inline element.
    class InlineFeedbackForm < Decidim::Form
      mimic :feedback

      attribute :rating, Integer
      attribute :metadata, Hash
      attribute :feedbackable_gid, String

      validates :rating, presence: true

      def feedbackable
        @feedbackable ||= GlobalID::Locator.locate_signed feedbackable_gid
      end
    end
  end
end
