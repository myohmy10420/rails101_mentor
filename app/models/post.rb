# frozen_string_literal: true
class Post < ApplicationRecord
  include AASM

  belongs_to :author, class_name: "User", foreign_key: :user_id
  belongs_to :group

  validates :content, presence: true

  scope :recent, -> { order("created_at DESC") }
  scope :once_published, -> { where.not(published_at: nil) }

  enum status: {
    pending: 0,
    verifying: 1,
    publish: 2,
    unapprove: 3,
    cancel: 4, # by post author
    block: 5 # by group owner
  }

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :verifying, :publish, :unapprove, :cancel, :block

    event :submit, after: :clean_published_at do
      transitions from: %i(pending verifying publish unapprove), to: :verifying
    end

    event :approve, after: :stamp_published_at do
      transitions from: :verifying, to: :publish
    end

    event :unapprove do
      transitions from: :verifying, to: :unapprove
    end

    event :cancel do
      transitions from: %i(pending verifying publish unapprove), to: :cancel
    end

    event :block do
      transitions from: %i(pending verifying publish unapprove), to: :block
    end
  end

  def status_editable?
    status.in?(%w(pending verifying publish unapprove))
  end

  def clean_published_at
    update(published_at: nil)
  end

  def stamp_published_at
    update(published_at: Time.zone.now)
  end
end
