# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action unless user
          return permission_action unless permission_action.scope == :admin

          unless user.admin?
            disallow!
            return permission_action
          end

          if read_admin_dashboard_action?
            allow!
            return permission_action
          end

          allowed_recipient_group_action?
          allowed_feedback_action?

          permission_action
        end

        private

        def recipient_group
          @recipient_group ||= context.fetch(:recipient_group, nil)
        end

        def feedback
          @feedback ||= context.fetch(:feedback, nil)
        end

        def allowed_recipient_group_action?
          return unless permission_action.subject == :recipient_group

          case permission_action.action
          when :create, :read
            allow!
          when :update, :destroy
            toggle_allow(recipient_group.present?)
          end
        end

        def allowed_feedback_action?
          return unless permission_action.subject == :feedback

          case permission_action.action
          when :create, :read, :export
            allow!
          when :update
            toggle_allow(feedback.present?)
          end
        end

        def read_admin_dashboard_action?
          permission_action.action == :read &&
            permission_action.subject == :admin_dashboard
        end
      end
    end
  end
end
