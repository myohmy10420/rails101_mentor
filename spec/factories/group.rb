# frozen_string_literal: true
FactoryBot.define do
  factory :group do
    owner { create(:user) }
    title { "title" }
    description { "description" }
  end
end
