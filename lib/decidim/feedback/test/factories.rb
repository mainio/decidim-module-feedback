# frozen_string_literal: true

def generate_metadata_conditions
  array = []
  rand(1..6).times.each do |_i|
    array << Array.new(2) { Faker::Verb.base }
  end
  array.to_h
end

FactoryBot.define do
  factory :feedback, class: "Decidim::Feedback::Feedback" do
    user { create(:user, :confirmed) }
    rating { rand(6) }
    body { Faker::Lorem.sentence }
    contact_request { rand(2) == 1 }
    metadata { { "#{Faker::Verb.base}": Faker::Verb.base.to_s, "#{Faker::Verb.base}": Faker::Verb.base.to_s } }
    feedbackable { create(:dummy_resource, component: create(:dummy_component, organization:)) }

    trait :contact do
      contact_request { true }
    end

    trait :no_contact do
      contact_request { false }
    end
  end

  factory :recipient_group, class: "Decidim::Feedback::RecipientGroup" do
    name { generate_localized_title }
    recipient_emails { Array.new(rand(1..6)) { Faker::Internet.email } }
    metadata_conditions { generate_metadata_conditions }
  end
end
