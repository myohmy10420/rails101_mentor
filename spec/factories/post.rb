# frozen_string_literal: true
FactoryBot.define do
  factory :post do
    association :user
    association :group
    content { "content" }
  end
end
