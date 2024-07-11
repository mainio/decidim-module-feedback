# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      class RecipientGroupsController < Decidim::Feedback::Admin::ApplicationController
        include Paginable

        layout "decidim/admin/feedbacks"

        helper_method :recipient_group, :blank_recipient, :blank_condition

        add_breadcrumb_item_from_menu :admin_feedback_menu

        def index
          enforce_permission_to :read, :recipient_group

          @groups = collection.page(params[:page]).per(15)
        end

        def new
          enforce_permission_to :create, :recipient_group
          @form = form(RecipientGroupForm).from_model(
            Decidim::Feedback::RecipientGroup.new
          )
        end

        def edit
          enforce_permission_to(:update, :recipient_group, recipient_group:)

          @form = form(RecipientGroupForm).from_model(recipient_group)
        end

        def create
          enforce_permission_to :create, :recipient_group
          @form = form(RecipientGroupForm).from_params(
            params,
            current_organization:
          )

          AddRecipientGroup.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("recipient_groups.create.success", scope: "decidim.feedback.admin")
              redirect_to recipient_groups_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("recipient_groups.create.error", scope: "decidim.feedback.admin")
              render action: "new"
            end
          end
        end

        def update
          enforce_permission_to(:update, :recipient_group, recipient_group:)
          @form = form(RecipientGroupForm).from_params(
            params,
            current_organization:
          )

          UpdateRecipientGroup.call(@form, recipient_group) do
            on(:ok) do
              flash[:notice] = I18n.t("recipient_groups.update.success", scope: "decidim.feedback.admin")
              redirect_to recipient_groups_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("recipient_groups.update.error", scope: "decidim.feedback.admin")
              render action: "edit"
            end
          end
        end

        def destroy
          enforce_permission_to(:destroy, :recipient_group, recipient_group:)
          recipient_group.destroy!

          flash[:notice] = I18n.t("recipient_groups.destroy.success", scope: "decidim.feedback.admin")

          redirect_to recipient_groups_path
        end

        private

        def recipient_group
          @recipient_group ||= Decidim::Feedback::RecipientGroup.find_by(
            organization: current_organization,
            id: params[:id]
          )
        end

        def collection
          @collection ||= Decidim::Feedback::RecipientGroup.where(
            organization: current_organization
          )
        end

        def blank_recipient
          @blank_recipient ||= Admin::RecipientForm.new
        end

        def blank_condition
          @blank_condition ||= Admin::ConditionForm.new
        end
      end
    end
  end
end
