# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Feedback::Admin

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil

        routes do
          resources :feedbacks, only: [:index, :show] do
            collection do
              post :export

              resources :recipient_groups, except: [:show]
            end
          end

          root to: "feedbacks#index"
        end

        initializer "decidim_feedbacks_admin.mount_routes", before: "decidim_admin.mount_routes" do
          # Mount the engine routes to Decidim::Core::Engine because otherwise
          # they would not get mounted properly.
          Decidim::Admin::Engine.routes.append do
            mount Decidim::Feedback::Admin::Engine => "/"
          end
        end

        initializer "decidim_feedbacks_admin.admin_menu" do
          Decidim.menu :admin_menu do |menu|
            menu.add_item :admin_feedback_menu,
                          I18n.t("menu.admin_menu.feedback", scope: "decidim.feedback.admin"),
                          decidim_feedback_admin.feedbacks_path,
                          icon_name: "megaphone-line",
                          position: 6.1,
                          active: :inclusive,
                          if: allowed_to?(:update, :organization, organization: current_organization)
          end
        end

        initializer "decidim_feedback_admin.menu", after: "decidim_feedbacks_admin.admin_menu" do
          Decidim::Feedback::Admin::Menu.register_admin_feedback_menu!
        end

        initializer "decidim_core.register_icons", after: "decidim_core.add_social_share_services" do
          Decidim.icons.register(name: "megaphone-line", icon: "megaphone-line", category: "system", description: "", engine: :core)
        end
      end
    end
  end
end
