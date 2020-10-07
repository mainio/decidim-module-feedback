# frozen_string_literal: true

module Decidim
  module Feedback
    # This cell renders the feedback details at the admin panel and in the
    # notification emails.
    class FeedbackDetailsCell < Decidim::ViewModel
      include LayoutHelper
      include Decidim::ApplicationHelper
      include Decidim::Admin::IconLinkHelper
      include Decidim::Messaging::ConversationHelper

      delegate :user_signed_in?, to: :controller

      private

      def show_email?
        options[:show_email]
      end

      def show_email_link?
        options[:show_email_link]
      end

      def show_contact?
        options[:show_contact]
      end

      def show_contact_link?
        return false unless presented_user

        presented_user.can_be_contacted? && presented_user.nickname != present(current_user).nickname
      end

      def resource_link
        return unless model.feedbackable

        @resource_link ||= Decidim::ResourceLocatorPresenter.new(model.feedbackable).url
      end

      def presented_user
        return unless model.user

        @presented_user ||= present(model.user)
      end

      def decidim_admin
        Decidim::Admin::Engine.routes.url_helpers
      end
    end
  end
end
