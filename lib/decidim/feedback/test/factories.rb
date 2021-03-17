# frozen_string_literal: true

FactoryBot.define do
  factory :feedback, class: "Decidim::Feedback::Feedback" do
    user { create(:user, :confirmed) }
    rating { rand(6) }
    body { ::Faker::Lorem.sentence }
    contact_request { rand(2) == 1 }
    metadata { { "action": "publish", "context": "your_resource" } }
    feedbackable { create(:dummy_resource, component: create(:dummy_component, organization: organization)) }
  end
end
