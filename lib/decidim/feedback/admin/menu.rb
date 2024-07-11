# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      class Menu
        def self.register_admin_feedback_menu!
          Decidim.menu :admin_feedback_menu do |menu|
            menu.add_item :feedbacks,
                          I18n.t("menu.feedbacks", scope: "decidim.feedback.admin"),
                          decidim_feedback_admin.feedbacks_path,
                          icon_name: "megaphone-line",
                          active: current_page?(decidim_feedback_admin.feedbacks_path),
                          if: allowed_to?(:read, :feedback)
            menu.add_item :recipient_group,
                          I18n.t("menu.recipient_groups", scope: "decidim.feedback.admin"),
                          decidim_feedback_admin.recipient_groups_path,
                          icon_name: "mail-line",
                          active: :inclusive,
                          if: allowed_to?(:read, :recipient_group)
          end
        end
      end
    end
  end
end
