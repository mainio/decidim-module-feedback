# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      class ExportJob < ApplicationJob
        include Decidim::PrivateDownloadHelper

        queue_as :default

        def perform(user, organization, name, format)
          export_data = Decidim::Exporters.find_exporter(format).new(
            Decidim::Feedback::Feedback.where(organization:),
            FeedbackSerializer
          ).export

          private_export = attach_archive(export_data, name, user)

          ExportMailer.export(user, private_export).deliver_now
        end
      end
    end
  end
end
