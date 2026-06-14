class Reflection < ApplicationRecord
  belongs_to :book

  after_create :log_activity

  private

  def log_activity
    return unless book.user
    Activity.log(user: book.user, action_type: 'reflection_written', trackable: self)
  end
end
