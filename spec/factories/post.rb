# frozen_string_literal: true
FactoryBot.define do
  factory :post do
    author { create(:user) }
    association :group
    content { "content" }
  end
end
