# frozen_string_literal: true

require "spec_helper"

describe Decidim::Feedback::Admin::FeedbacksController do
  routes { Decidim::Feedback::Admin::Engine.routes }

  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:resource) { create(:dummy_resource) }
  let(:params) { { favoritable_gid: resource.to_sgid.to_s } }

  before do
    request.env["decidim.current_organization"] = user.organization
    sign_in user, scope: :user
  end

  describe "GET index" do
    it "renders the index view" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(subject).to render_template("decidim/feedback/admin/feedbacks/index")
    end
  end

  describe "GET show" do
    let(:feedback) { create(:feedback, organization:, user:) }

    it "renders the show view" do
      get :show, params: { id: feedback.id, format: :js }, xhr: true

      expect(response).to have_http_status(:ok)
      expect(subject).to render_template("decidim/feedback/admin/feedbacks/show")
    end
  end

  describe "POST export" do
    let(:export_format) { "CSV" }

    it "creates job" do
      expect(Decidim::Feedback::Admin::ExportJob).to receive(:perform_later)
        .with(user, organization, "feedbacks", export_format)

      post :export, params: params.merge(format: export_format)
    end
  end
end
