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

        @resource_link ||=
          if model.feedbackable.is_a?(Decidim::Component)
            EngineRouter.main_proxy(model.feedbackable).root_path
          else
            Decidim::ResourceLocatorPresenter.new(model.feedbackable).url
          end
      end

      def conversation_link
        return unless sender

        # Note that this can be nil in case the user does not want to be
        # contacted on the platform through their profile settings.
        @conversation_link ||= current_or_new_conversation_path_with(sender)
      end

      def presented_user
        return unless sender

        @presented_user ||= present(sender)
      end

      def sender
        return unless model.user
        return if model.user.deleted?

        model.user
      end

      def decidim_admin
        Decidim::Admin::Engine.routes.url_helpers
      end
    end
  end
end
