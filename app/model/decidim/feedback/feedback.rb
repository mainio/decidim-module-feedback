# frozen_string_literal: true

module Decidim
  module Feedback
    class Feedback < ApplicationRecord
      include Decidim::DataPortability

      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"
      belongs_to :feedbackable, foreign_key: "decidim_feedbackable_id", foreign_type: "decidim_feedbackable_type", polymorphic: true
      belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User"
    end
  end
end
