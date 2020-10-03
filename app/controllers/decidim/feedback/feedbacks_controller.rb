# frozen_string_literal: true

module Decidim
  module Feedback
    class FeedbacksController < Decidim::ApplicationController
      include Decidim::FormFactory

      before_action :authenticate_user!

      skip_before_action :store_current_location

      def create
        enforce_permission_to :create, :feedback

        @form = form(Decidim::Feedback::FeedbackForm).from_params(params)
        @feedbackable = @form.feedbackable

        Decidim::Feedback::SendFeedback.call(@form, current_user) do
          on(:ok) do
            render :create
          end

          on(:invalid) do
            render json: { error: I18n.t("create.error", scope: "decidim.feedback") }, status: :unprocessable_entity
          end
        end
      end

      def permission_scope
        :public
      end

      def permission_class_chain
        [
          ::Decidim::Feedback::Permissions,
          ::Decidim::Permissions
        ]
      end

      private

      attr_reader :types, :button_options
    end
  end
end
