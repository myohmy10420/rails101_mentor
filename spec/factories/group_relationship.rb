# frozen_string_literal: true
FactoryBot.define do
  factory :group_relationship do
    association :user
    association :group
  end
end
