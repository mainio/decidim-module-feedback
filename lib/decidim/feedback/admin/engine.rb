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

        initializer "decidim_feedbacks_admin.assets" do |app|
          app.config.assets.precompile += %w(decidim_feedback_manifest.js)
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
            menu.item I18n.t("menu.feedbacks", scope: "decidim.feedback.admin"),
                      decidim_feedback_admin.feedbacks_path,
                      icon_name: "bullhorn",
                      position: 6.1,
                      active: :inclusive,
                      if: allowed_to?(:update, :organization, organization: current_organization)
          end
        end
      end
    end
  end
end
