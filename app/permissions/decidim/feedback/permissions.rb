# frozen_string_literal: true

module Decidim
  module Feedback
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless permission_action.scope == :public
        return permission_action unless user

        feedback_action?

        permission_action
      end

      private

      def feedback_action?
        return unless permission_action.subject == :feedback

        allow! if permission_action.action == :create
      end
    end
  end
end
