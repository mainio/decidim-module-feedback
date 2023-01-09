# frozen_string_literal: true

require "spec_helper"

module Decidim::Feedback::Admin
  describe AddRecipientGroup do
    subject { described_class.new(form) }

    let(:organization) { create(:organization) }
    let(:invalid) { false }
    let(:form) do
      double(
        invalid?: invalid,
        current_organization: organization,
        name: ::Faker::Company.bs,
        recipient_emails: Array.new(rand(6)) { ::Faker::Internet.email },
        metadata_conditions: { proposals: "publish", voting: "finish" }
      )
    end

    describe "#call" do
      context "when everything is ok" do
        it "broadcasts ok" do
          expect { subject.call }.to broadcast(:ok)
        end

        it "creates group" do
          subject.call
          created_group = Decidim::Feedback::RecipientGroup.last
          expect(created_group.organization).to eq(organization)
          expect(created_group.name).to eq(form.name)
          expect(created_group.recipient_emails).to eq(form.recipient_emails)
          expect(created_group.metadata_conditions).to eq(form.metadata_conditions.stringify_keys)
        end
      end
    end
  end
end
