# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Feedback
    describe FeedbacksController do
      routes { Decidim::Feedback::Engine.routes }

      let(:organization) { create(:organization) }
      let(:user) { create(:user, :confirmed, organization:) }
      let(:feedback_body) { ::Faker::Lorem.sentence }
      let(:rating) { rand(6) }
      let(:contact_request) { rand(2) }
      let(:params) { { "rating" => rating, "body" => feedback_body, "contact_request" => contact_request, feedbackable_gid: dummy_resource.to_sgid.to_s } }
      let(:dummy_resource) { create(:dummy_resource) }

      before do
        request.env["decidim.current_organization"] = user.organization
        sign_in user, scope: :user
      end

      describe "POST create" do
        it "creates a new feedback" do
          post(:create, format: :js, params:)
          expect(Decidim::Feedback::Feedback.last.rating).to eq(rating)
          expect(Decidim::Feedback::Feedback.last.body).to eq(feedback_body)
          expect(Decidim::Feedback::Feedback.last.contact_request).to eq(contact_request == 1)
        end
      end
    end
  end
end
