# frozen_string_literal: true

require "spec_helper"

module Decidim::Feedback::Admin
  describe UpdateRecipientGroup do
    subject { described_class.new(form, recipient_group) }

    let(:organization) { create(:organization) }
    let(:recipient_group) { create(:recipient_group, organization: organization) }
    let(:invalid) { false }
    let(:form) do
      double(
        invalid?: invalid,
        name: ::Faker::Company.bs,
        recipient_emails: Array.new(rand(6)) { ::Faker::Internet.email },
        metadata_conditions: { favorites: "create" }
      )
    end

    describe "#call" do
      context "when everything is ok" do
        it "broadcasts ok" do
          expect { subject.call }.to broadcast(:ok)
        end

        it "updates recipient group" do
          subject.call

          updated_group = Decidim::Feedback::RecipientGroup.last
          expect(updated_group.name).to eq(form.name)
          expect(updated_group.recipient_emails).to eq(form.recipient_emails)
          expect(updated_group.metadata_conditions).to eq(form.metadata_conditions.stringify_keys)
        end
      end
    end
  end
end
