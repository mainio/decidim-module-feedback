# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      # A form object to be used to define recipients for feedback emails.
      class RecipientForm < Decidim::Form
        mimic :feedback_recipient

        attribute :email, String
        attribute :position, Integer
        attribute :deleted, Boolean, default: false

        validates :email, presence: true, 'valid_email_2/email': { disposable: true }, unless: :deleted

        def to_param
          return id if id.present?

          "recipient-id"
        end
      end
    end
  end
end
