# frozen_string_literal: true

require "spec_helper"

module Decidim::Feedback
  describe FeedbackMailer, type: :mailer do
    let(:organization) { create(:organization) }
    let(:feedback) { create(:feedback, organization: organization) }
    let(:recipient_email) { ::Faker::Internet.email }

    describe "#feedback_received" do
      let(:mail) { described_class.feedback_received(feedback, recipient_email) }

      it "has subject" do
        expect(mail.subject).to eq("Feedback from #{organization.name}")
      end

      it "delivers the email to the recipient" do
        expect(mail.to).to eq([recipient_email])
      end

      context "when sender wants to be contacted" do
        let(:feedback) { create(:feedback, :contact, organization: organization) }

        it "has senders email" do
          expect(mail.reply_to).to eq([feedback.user.email])
        end
      end

      context "when sender doesnt want to be contacted" do
        let(:feedback) { create(:feedback, :no_contact, organization: organization) }

        it "doesnt have reply_to email" do
          expect(mail.reply_to).to be_nil
        end
      end
    end
  end
end
