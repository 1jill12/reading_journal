class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true, optional: true

  TYPES = %w[book_added book_finished reflection_written bingo_covered].freeze

  validates :action_type, inclusion: { in: TYPES }

  scope :recent, -> { order(created_at: :desc) }

  def self.log(user:, action_type:, trackable:)
    create!(user: user, action_type: action_type, trackable: trackable)
  rescue ActiveRecord::RecordInvalid
    nil
  end
end
