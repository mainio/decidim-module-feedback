# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs", prepend: true)

Decidim::Webpacker.register_entrypoints(
  decidim_feedback: "#{base_path}/app/packs/entrypoints/decidim_feedback.js",
  decidim_feedback_admin: "#{base_path}/app/packs/entrypoints/decidim_feedback_admin.js",
  decidim_feedback_modal_admin: "#{base_path}/app/packs/entrypoints/decidim_feedback_modal_admin.js"
)

Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/feedback/feedback-form")
