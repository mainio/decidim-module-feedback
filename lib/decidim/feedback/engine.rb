# frozen_string_literal: true

module Decidim
  module Feedback
    # This is an engine that controls the feedback functionality.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Feedback

      routes do
        resources :feedbacks, only: [:new, :create]

        root to: "feedbacks#index"
      end

      initializer "decidim_ideas.assets" do |app|
        app.config.assets.precompile += %w(decidim_feedback_manifest.js
                                           decidim/feedback/feedback_modal.js)
      end

      initializer "decidim_feedback.mount_routes", before: :add_routing_paths do
        Decidim::Core::Engine.routes.append do
          mount Decidim::Feedback::Engine => "/"
        end
      end

      initializer "decidim_feedback.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Feedback::Engine.root}/app/cells")
      end
    end
  end
end
