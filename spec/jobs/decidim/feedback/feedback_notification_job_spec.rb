# frozen_string_literal: true

require "spec_helper"

describe Decidim::Feedback::FeedbackNotificationJob do
  let(:organization) { create(:organization) }
  let(:feedback) { create(:feedback, :contact, organization: organization) }
  let!(:recipient_group) do
    create(
      :recipient_group,
      organization: organization,
      recipient_emails: [recipient_email],
      metadata_conditions: []
    )
  end
  let(:recipient_email) { ::Faker::Internet.email }

  context "when recipient group metadata conditions are blank" do
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

    describe "perform" do
      let(:mailer) { double :mailer }

      it "sends an email with the result of the export" do
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
