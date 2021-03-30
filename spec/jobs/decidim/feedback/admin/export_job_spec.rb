# frozen_string_literal: true

require "spec_helper"

describe Decidim::Feedback::Admin::ExportJob do
  let(:organization) { create(:organization) }
  let!(:user) { create(:user, :confirmed, :admin, organization: organization) }

  it "sends an email with the result of the export" do
    described_class.perform_now(user, organization, "feedbacks", "CSV")

    email = last_email
    expect(email.subject).to include("feedbacks")
    attachment = email.attachments.first

    expect(attachment.read.length).to be_positive
    expect(attachment.mime_type).to eq("application/zip")
    expect(attachment.filename).to match(/^feedbacks-[0-9]+-[0-9]+-[0-9]+-[0-9]+\.zip$/)
  end
end
