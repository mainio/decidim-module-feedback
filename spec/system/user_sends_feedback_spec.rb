# frozen_string_literal: true

require "spec_helper"

describe "Feedback" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization:) }
  let(:html_body) do
    Decidim::ViewModel.cell("decidim/feedback/feedback_modal", resource, context: { current_user: user }).call.to_s
  end
  let(:resource) { create(:dummy_resource, component:) }
  let(:component) { create(:dummy_component, organization:) }
  let(:rating) { rand(1..5) }
  let(:html_head) { "" }
  let(:html_document) do
    document_inner = html_body
    template.instance_eval do
      <<~HTML.strip
        <!doctype html>
        <html lang="en">
        <head>
          <title>Feedback Modal Test</title>
          #{stylesheet_pack_tag "decidim_core"}
          #{javascript_pack_tag "decidim_core", "decidim_feedback"}
        </head>
        <body>
          #{document_inner}
        </body>
        </html>
      HTML
    end
  end
  let(:template_class) do
    Class.new(ActionView::Base) do
      def protect_against_forgery?
        false
      end
    end
  end
  let(:template) { template_class.new(ActionView::LookupContext.new(ActionController::Base.view_paths), {}, []) }

  before do
    switch_to_host(organization.host)
    final_html = html_document
    favicon = ""

    Rails.application.routes.draw do
      mount Decidim::Feedback::Engine => "/"
      get "test_feedback_cell", to: ->(_) { [200, {}, [final_html]] }
      get "/favicon.ico", to: ->(_) { [200, {}, [favicon]] }
    end

    login_as user, scope: :user
  end

  after do
    Rails.application.reload_routes!
  end

  it "creates feedback" do
    visit "/test_feedback_cell"

    expect_no_js_errors
    expect(page).to have_content("Give feedback on your experience")

    within("label[for='feedback_feedback_rating_#{rating}']") do
      find("svg").click
    end

    within "#feedback_feedback_body" do
      fill_in with: Faker::Lorem.paragraph
    end

    click_on "Send feedback"
    expect(page).to have_content("Thank you for your feedback")
    expect(Decidim::Feedback::Feedback.last.rating).to eq(rating)
  end
end

Decidim::Feedback::FeedbackModalCell.class_eval do
  define_method :form_authenticity_token do
    # Just generate random string in test
    SecureRandom.hex(8)
  end
end
