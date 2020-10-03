# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Feedback
    describe FeedbackController, type: :controller do
      let(:organization) { create(:organization) }
      let(:user) { create(:user, :confirmed, organization: organization) }

      before do
        request.env["decidim.current_organization"] = user.organization
        sign_in user, scope: :user
      end

      describe "GET index" do
        it "shows the follows" do
          # TODO
        end
      end

      describe "POST create" do
        it "creates a new follow" do
          # TODO
        end
      end
    end
  end
end
