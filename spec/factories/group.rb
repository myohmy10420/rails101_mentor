# frozen_string_literal: true
FactoryBot.define do
  factory :group do
    association :user
    title { "title" }
    description { "description" }
  end
end
