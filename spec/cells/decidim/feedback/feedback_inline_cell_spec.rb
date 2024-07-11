# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Feedback
    describe "FeedbackInlineCell" do
      controller Decidim::ApplicationController

      let(:current_organization) { create(:organization) }
      let(:current_user) { create(:user, organization: current_organization) }
      let(:model) { create(:dummy_resource) }
      let(:options) { { title: "Give feedback", content_id: "feedback_inline", metadata: { key: "value" } } }
      let(:cell_instance) { cell("decidim/feedback/feedback_inline", model, options) }

      before do
        allow(controller).to receive(:current_organization).and_return(current_organization)
        allow(controller).to receive(:current_user).and_return(current_user)
      end

      describe "rendering" do
        subject { cell_instance.call }

        it "renders the title" do
          expect(subject).to have_content("Give feedback")
        end

        it "renders the feedback form" do
          expect(subject).to have_css(".feedback-form.new_feedback")
        end
      end

      describe "#feedback_registered?" do
        subject { cell_instance.send(:feedback_registered?) }

        context "when feedback is registered" do
          let!(:feedback) { create(:feedback, feedbackable: model, organization: current_organization, user: current_user, metadata: { key: "value" }) }

          it { is_expected.to be_truthy }
        end

        context "when feedback is not registered" do
          it { is_expected.to be_falsey }
        end
      end

      describe "#feedback_form" do
        subject { cell_instance.send(:feedback_form) }

        it "initializes a new feedback form with default values" do
          expect(subject.body).to eq("")
          expect(subject.rating).to eq(0)
          expect(subject.contact_request).to be_falsey
          expect(subject.metadata).to eq({ key: "value" })
          expect(subject.feedbackable_gid).not_to eq("")
        end
      end
    end
  end
end
