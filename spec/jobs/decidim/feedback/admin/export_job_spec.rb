# frozen_string_literal: true

require "spec_helper"

describe Decidim::Feedback::Admin::ExportJob do
  let(:organization) { create(:organization) }
  let!(:user) { create(:user, :confirmed, :admin, organization:) }

  it "sends an email with the result of the export" do
    described_class.perform_now(user, organization, "feedbacks", "CSV")

    email = last_email
    expect(email.subject).to include("feedbacks")
    expect(email.body.encoded).to include("download_your_data")
    expect(email.body.encoded).to include("Your download is ready")
  end
end
