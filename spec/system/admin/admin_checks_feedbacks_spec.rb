# frozen_string_literal: true

require "spec_helper"

describe "Admin checks feedbacks", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit "/admin/feedbacks"
  end

  context "when there are no feedback" do
    it "shows dummy message" do
      expect(page).to have_content("No feedback yet")
    end
  end

  context "when there are feedbacks" do
    let!(:feedbacks) { create_list(:feedback, 3, organization: organization) }

    before do
      visit current_path
    end

    it "shows feedbacks" do
      feedbacks.each do |feedback|
        expect(page).to have_content(feedback.user.name)
        expect(page).to have_content(feedback.body)
        expect(page).to have_content(feedback.rating)
      end
    end

    it "shows export dropdown" do
      expect(page).to have_content("Export")
    end
  end

  context "when there are feedback" do
    let!(:feedback) { create(:feedback, organization: organization) }

    before do
      visit current_path
    end

    it "opens reveal when clicking show" do
      within ".table-list__actions", match: :first do
        first(:link, "Show").click
      end

      expect(page).to have_css(".reveal__title")
      expect(page).to have_content("Feedback information")
      expect(page).to have_content("Feedback:\n#{feedback.body}")
    end
  end
end
