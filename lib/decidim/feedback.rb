# frozen_string_literal: true

require_relative "feedback/version"
require_relative "feedback/engine"
require_relative "feedback/admin"

module Decidim
  module Feedback
    autoload :FeedbackSerializer, "decidim/feedback/feedback_serializer"
  end
end
