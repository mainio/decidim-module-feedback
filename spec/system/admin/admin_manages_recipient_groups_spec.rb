# frozen_string_literal: true

require "spec_helper"

describe "Admin manages recipient groups", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }
  let(:recipient_group_name) { ::Faker::GreekPhilosophers.quote }
  let(:recipient_email) { ::Faker::Internet.email }
  let(:condition_key) { ::Faker::Verb.base }
  let(:condition_value) { ::Faker::Verb.ing_form }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit "/admin/feedbacks/recipient_groups"
  end

  describe "New recipient group" do
    it "adds recipient group" do
      first(:link, "New recipient group").click
      within ".card-section", match: :first do
        fill_in_i18n(
          :feedback_recipient_group_name,
          ".label--tabs",
          en: "#{recipient_group_name} en",
          es: "#{recipient_group_name} es",
          ca: "#{recipient_group_name} ca"
        )
      end
      click_button "Add recipient"
      within "label[for^=recipients" do
        fill_in with: recipient_email
      end
      click_button "Add condition"
      within "label[for$=key]" do
        fill_in with: condition_key
      end
      within "label[for$=value]" do
        fill_in with: condition_value
      end
      click_button "Add"
      saved_recipient_group = Decidim::Feedback::RecipientGroup.last
      expect(Decidim::Feedback::RecipientGroup.count).to eq(1)
      expect(saved_recipient_group.name["en"]).to eq("#{recipient_group_name} en")
      expect(saved_recipient_group.name["es"]).to eq("#{recipient_group_name} es")
      expect(saved_recipient_group.name["ca"]).to eq("#{recipient_group_name} ca")
      expect(saved_recipient_group.recipient_emails).to include(recipient_email)
      expect(saved_recipient_group.metadata_conditions[condition_key]).to eq(condition_value)
    end
  end
end
