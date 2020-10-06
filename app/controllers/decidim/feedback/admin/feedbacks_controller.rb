# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      class FeedbacksController < Decidim::Feedback::Admin::ApplicationController
        include Paginable

        layout "decidim/admin/feedback"

        helper_method :feedback, :average_rating

        def index
          enforce_permission_to :read, :feedback
          @feedbacks = collection.page(params[:page]).per(15)
        end

        def show
          enforce_permission_to :read, :feedback, feedback: feedback
        end

        def export
          enforce_permission_to :export, :feedback
          name = "feedbacks"

          ExportJob.perform_later(
            current_user,
            current_organization,
            name,
            params[:format] || "json"
          )

          flash[:notice] = I18n.t("exports.notice", scope: "decidim.admin")

          redirect_to feedbacks_path
        end

        private

        def feedback
          @feedback ||= Decidim::Feedback::Feedback.find_by(
            organization: current_organization,
            id: params[:id]
          )
        end

        def collection
          @collection ||= Decidim::Feedback::Feedback.where(
            organization: current_organization
          ).order(created_at: :desc)
        end

        def average_rating
          return unless collection.any?

          collection.where.not(rating: nil).average(:rating)
        end
      end
    end
  end
end