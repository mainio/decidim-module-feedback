# frozen_string_literal: true

require "spec_helper"

describe "AdminRecipientGroups" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:recipient_group_name) { Faker::GreekPhilosophers.quote }
  let(:recipient_email) { Faker::Internet.email }
  let(:condition_key) { Faker::Verb.base }
  let(:condition_value) { Faker::Verb.ing_form }

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
      click_on "Add recipient"
      within "label[for^=recipients" do
        fill_in with: recipient_email
      end
      click_on "Add condition"
      within "label[for$=key]" do
        fill_in with: condition_key
      end
      within "label[for$=value]" do
        fill_in with: condition_value
      end
      click_on "Add"
      saved_recipient_group = Decidim::Feedback::RecipientGroup.last
      expect(Decidim::Feedback::RecipientGroup.count).to eq(1)
      expect(saved_recipient_group.name["en"]).to eq("#{recipient_group_name} en")
      expect(saved_recipient_group.name["es"]).to eq("#{recipient_group_name} es")
      expect(saved_recipient_group.name["ca"]).to eq("#{recipient_group_name} ca")
      expect(saved_recipient_group.recipient_emails).to include(recipient_email)
      expect(saved_recipient_group.metadata_conditions[condition_key]).to eq(condition_value)
    end
  end

  context "when there is recipient groups" do
    let(:group_amount) { rand(1..6) }
    let!(:recipient_groups) { create_list(:recipient_group, group_amount, organization:) }

    before do
      visit current_path
    end

    describe "#index" do
      it "shows names of recipient groups" do
        recipient_groups.each do |recipient_group|
          expect(page).to have_content(recipient_group.name["en"])
        end
      end
    end

    describe "#edit" do
      before do
        find(:css, ".action-icon.action-icon--new", match: :first).click
      end

      it "can edit group name" do
        fill_in "feedback_recipient_group_name_en", with: "Foo bar"
        click_on "Save"
        expect(page).to have_content("Recipient group successfully updated")
        expect(page).to have_content("Foo bar")
      end
    end

    describe "#delete" do
      it "reveals confirmation" do
        find(:css, ".action-icon.action-icon--remove", match: :first).click
        expect(page).to have_content("Confirm delete")
      end

      it "deletes recipient group" do
        find(:css, ".action-icon.action-icon--remove", match: :first).click
        expect(page).to have_content("Confirm delete")
        click_on "OK"
        expect(page).to have_content("Recipient group successfully deleted")
      end
    end
  end
end
