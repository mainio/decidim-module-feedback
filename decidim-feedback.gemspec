# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/feedback/version"

Gem::Specification.new do |spec|
  spec.name = "decidim-feedback"
  spec.version = Decidim::Feedback.version
  spec.required_ruby_version = ">= 3.1"
  spec.authors = ["Antti Hukkanen"]
  spec.email = ["antti.hukkanen@mainiotech.fi"]

  spec.summary = "Adds possibility to add feedback modals to Decidim."
  spec.description = "Developers can configure feedback modals to any section in their Decidim instance."
  spec.homepage = "https://github.com/mainio/decidim-module-feedback"
  spec.license = "AGPL-3.0"

  spec.files = Dir[
    "{app,config,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "Rakefile",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "decidim-admin", Decidim::Feedback.decidim_version
  spec.add_dependency "decidim-core", Decidim::Feedback.decidim_version

  spec.add_development_dependency "decidim-dev", Decidim::Feedback.decidim_version
  spec.metadata["rubygems_mfa_required"] = "true"
end
