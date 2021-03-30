# frozen_string_literal: true

require "spec_helper"

describe Decidim::Feedback::Admin::RecipientGroupForm do
  subject { described_class.from_model(recipient_group) }

  let(:organization) { create(:organization) }
  let(:recipient_group) { create(:recipient_group, organization: organization) }

  describe "#recipient_emails" do
    it "returns emails" do
      expect(subject.recipient_emails).to eq(recipient_group.recipient_emails)
    end

    context "when same email addresses twice" do
      let(:recipient_group) do
        create(
          :recipient_group,
          organization: organization,
          recipient_emails: emails
        )
      end
      let(:emails) { ["foo@example.org", "bar@example.org", "foo@example.org"] }

      it "returns email just once" do
        expect(subject.recipient_emails).to eq(emails.take(2))
      end

      context "when recipients are deleted" do
        before do
          subject.recipients.each { |recipient| recipient.deleted = true }
        end

        it "returns empty array" do
          expect(subject.recipient_emails).to eq([])
        end
      end
    end
  end

  describe "#metadata_conditions" do
    it "returns metadata_conditions" do
      expect(subject.metadata_conditions.stringify_keys).to eq(recipient_group.metadata_conditions)
    end
  end
end
