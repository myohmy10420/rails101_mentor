# frozen_string_literal: true
class GroupRelationship < ApplicationRecord
  belongs_to :group
  belongs_to :user
end
