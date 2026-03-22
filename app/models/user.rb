class User < ApplicationRecord
  THEMES = {
    'neutral'       => 'Neutral',
    'dark_academia' => 'Dark Academia'
  }.freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,               dependent: :destroy
  has_many :reviews,             dependent: :destroy
  has_many :reading_goals,       dependent: :destroy
  has_many :az_challenge_entries, dependent: :destroy
  has_many :user_bingo_cards, dependent: :destroy
  has_many :bingo_cards,      through: :user_bingo_cards
  has_many :activities,       dependent: :destroy

  # Follows — Instagram-style (asymmetric)
  has_many :active_follows,  class_name: 'Follow', foreign_key: :follower_id,  dependent: :destroy
  has_many :passive_follows, class_name: 'Follow', foreign_key: :following_id, dependent: :destroy
  has_many :following, through: :active_follows,  source: :following
  has_many :followers, through: :passive_follows, source: :follower

  validates :theme,    inclusion: { in: THEMES.keys }
  validates :username, uniqueness: { case_sensitive: false }, allow_blank: true,
                       format: { with: /\A[a-z0-9_]+\z/, message: "only lowercase letters, numbers, and underscores", allow_blank: true }

  def private_profile?
    private_profile == true
  end

  def display_name
    username.presence || email.split('@').first
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed_activities
    following_ids = following.pluck(:id)
    Activity.where(user_id: following_ids).recent
  end
end
