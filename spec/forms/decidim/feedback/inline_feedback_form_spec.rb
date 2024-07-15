# frozen_string_literal: true

require "spec_helper"

describe Decidim::Feedback::InlineFeedbackForm do
  subject { described_class.from_params(valid_attributes) }

  let(:feedbackable) { create(:dummy_resource) }
  let(:feedbackable_gid) { feedbackable.to_sgid.to_s }
  let(:valid_attributes) do
    {
      rating: 5,
      metadata: { some: "data" },
      feedbackable_gid:
    }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a rating" do
      subject.rating = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:rating]).to include("cannot be blank")
    end
  end

  describe "#feedbackable" do
    it "returns the feedbackable object" do
      expect(subject.feedbackable).to eq(feedbackable)
    end
  end
end
