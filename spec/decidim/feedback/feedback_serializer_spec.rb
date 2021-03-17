# frozen_string_literal: true

require "spec_helper"

module Decidim::Feedback
  describe FeedbackSerializer do
    let(:subject) { described_class.new(feedback) }
    let(:feedback) { create(:feedback, organization: organization) }
    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed) }
    let(:serialized) { subject.serialize }

    describe "#serializer" do
      it "includes the id" do
        expect(serialized).to include(id: feedback.id)
      end

      it "includes source" do
        expect(serialized[:source]).to include(id: feedback.feedbackable.id)
      end

      it "includes user" do
        expect(serialized[:user]).to include(id: feedback.user.id)
      end

      it "includes rating" do
        expect(serialized).to include(rating: feedback.rating)
      end

      it "includes body" do
        expect(serialized).to include(body: feedback.body)
      end

      it "includes contact request" do
        expect(serialized).to include(contact_request: feedback.contact_request)
      end

      it "includes metadata" do
        expect(serialized).to include(metadata: feedback.metadata)
      end
    end
  end
end
