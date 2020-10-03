# frozen_string_literal: true

require_relative "feedback/version"
require_relative "feedback/engine"

module Decidim
  module Feedback
    include ActiveSupport::Configurable

    # Defines whether admins should be notified about new feedback or not.
    config_accessor :notify_admins do
      true
    end

    # Extra emails that should be notified about new feedback.
    config_accessor :notify_emails do
      []
    end
  end
end
