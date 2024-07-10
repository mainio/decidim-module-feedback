# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      # A form object to be used to define recipient groups for feedbacks.
      class RecipientGroupForm < Decidim::Form
        include TranslatableAttributes

        mimic :feedback_recipient_group

        translatable_attribute :name, String
        attribute :recipients, Array[Decidim::Feedback::Admin::RecipientForm]
        attribute :conditions, Array[Decidim::Feedback::Admin::ConditionForm]

        validates :name, translatable_presence: true
        validates :recipient_emails, presence: true

        def map_model(model)
          self.recipients = model.recipient_emails.map do |email|
            RecipientForm.new(email:)
          end
          self.conditions = model.metadata_conditions.map do |key, value|
            ConditionForm.new(key:, value:)
          end
        end

        def recipient_emails
          @recipient_emails ||= recipients.reject(&:deleted).map(&:email).uniq
        end

        def metadata_conditions
          @metadata_conditions ||= conditions.reject(&:deleted).to_h { |c| [c.key, c.value] }
        end
      end
    end
  end
end
