# frozen_string_literal: true
class Post < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :group

  validates :content, presence: true

  scope :recent, -> { order("created_at DESC") }

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :publish, :unapprove, :cancel, :block
  end

  enum status: {
    pending: 0,
    publish: 1,
    unapprove: 2,
    cancel: 3, # by user
    block: 4 # by group owner
  }
end
