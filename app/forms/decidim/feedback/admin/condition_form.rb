# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      # A form object to be used to define feedback conditions for the
      # recipient group.
      class ConditionForm < Decidim::Form
        mimic :feedback_condition

        attribute :key, Symbol
        attribute :value, String
        attribute :position, Integer
        attribute :deleted, Boolean, default: false

        validates :key, presence: true, unless: :deleted
        validates :value, presence: true, unless: :deleted

        def to_param
          return id if id.present?

          "condition-id"
        end
      end
    end
  end
end
