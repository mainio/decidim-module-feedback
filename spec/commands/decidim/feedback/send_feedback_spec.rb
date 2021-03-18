# frozen_string_literal: true

require "spec_helper"

module Decidim::Feedback
  describe SendFeedback do
    subject { described_class.new(form, user) }

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed) }
    let(:resource) { create(:dummy_resource) }
    let(:body) { ::Faker::Lorem.sentence }
    let(:invalid) { false }
    let(:form) do
      double(
        invalid?: invalid,
        rating: 1,
        body: body,
        contact_request: rand(2) == 1,
        metadata: { "foo": "bar" },
        feedbackable: resource,
        current_organization: organization,
        user: user
      )
    end

    describe "#call" do
      context "when everything is ok" do
        it "broadcasts ok" do
          expect { subject.call }.to broadcast(:ok)
        end

        it "creates feedback" do
          expect { subject.call }.to change { Decidim::Feedback::Feedback.count }.by(1)
        end

        it "creates notification job" do
          expect(Decidim::Feedback::FeedbackNotificationJob).to receive(:perform_later)

          subject.call
        end
      end
    end
  end
end
