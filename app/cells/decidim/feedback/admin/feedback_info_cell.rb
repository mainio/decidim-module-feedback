# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      # This cell renders the feedback info modal at the admin panel.
      class FeedbackInfoCell < Decidim::ViewModel
        include LayoutHelper
        include Decidim::Admin::IconLinkHelper
        #include Decidim::SanitizeHelper
        #include Decidim::ResourceHelper

        private

        def modal_id
          options[:modal_id] || "feedback-info-modal"
        end

        def show_email_link?
          options[:show_email_link]
        end

        def resource_link
          return unless model.feedbackable

          @resource_link ||= Decidim::ResourceLocatorPresenter.new(model.feedbackable).url
        end

        def decidim_admin
          Decidim::Admin::Engine.routes.url_helpers
        end
      end
    end
  end
end
