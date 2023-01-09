# frozen_string_literal: true

require "spec_helper"

describe Decidim::Feedback::FeedbackNotificationJob do
  let(:organization) { create(:organization) }
  let(:feedback) { create(:feedback, :contact, organization: organization, metadata: metadata_conditions) }
  let(:recipient_email) { ::Faker::Internet.email }
  let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
  let(:metadata_conditions) { { context: "proposal" } }
  let!(:recipient_group) do
    create(
      :recipient_group,
      organization: organization,
      recipient_emails: [recipient_email],
      metadata_conditions: metadata_conditions
    )
  end
  let(:mailer) { double :mailer }

  context "when everything is OK" do
    it "sends an email" do
      allow(Decidim::Feedback::FeedbackMailer)
        .to receive(:feedback_received)
        .with(feedback, recipient_email)
        .and_return(mailer)
      expect(mailer)
        .to receive(:deliver_later)

      described_class.perform_now(feedback)
    end
  end

  context "when metadata conditions doesnt match" do
    let(:metadata_conditions) { { something: "else" } }

    before do
      feedback.metadata = { foo: "bar" }
      feedback.save!
    end

    describe "#perform" do
      it "doesnt send email" do
        allow(Decidim::Feedback::FeedbackMailer)
          .to receive(:feedback_received)
          .with(feedback, recipient_email)
          .and_return(mailer)
        expect(mailer)
          .not_to receive(:deliver_later)

        described_class.perform_now(feedback)
      end
    end
  end

  context "when recipient group metadata conditions are blank" do
    let(:metadata_conditions) { {} }

    describe "#perform" do
      it "sends an email" do
        allow(Decidim::Feedback::FeedbackMailer)
          .to receive(:feedback_received)
          .with(feedback, recipient_email)
          .and_return(mailer)
        expect(mailer)
          .to receive(:deliver_later)

        described_class.perform_now(feedback)
      end
    end
  end
end
