# frozen_string_literal: true

module Decidim
  module Feedback
    class FeedbacksController < Decidim::ApplicationController
      include Decidim::FormFactory

      before_action :authenticate_user!
      before_action :ensure_js_format!

      skip_before_action :store_current_location

      def create
        enforce_permission_to :create, :feedback

        @feedback_type = params[:feedback_type]
        form_class =
          if @feedback_type == "inline"
            Decidim::Feedback::InlineFeedbackForm
          else
            Decidim::Feedback::FeedbackForm
          end

        @form = form(form_class).from_params(params)
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

      def ensure_js_format!
        raise NotImplementedError if request.format != :js
      end

      private

      attr_reader :types, :button_options
    end
  end
end
