# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      class ExportJob < ApplicationJob
        queue_as :default

        def perform(user, organization, name, format)
          export_data = Decidim::Exporters.find_exporter(format).new(
            Decidim::Feedback::Feedback.where(organization:),
            FeedbackSerializer
          ).export

          ExportMailer.export(user, name, export_data).deliver_now
        end
      end
    end
  end
end
