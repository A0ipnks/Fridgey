class RoomMember < ApplicationRecord
  belongs_to :room
  belongs_to :user

  enum :role, { member: 0, admin: 1 }

  validates :user_id, uniqueness: { scope: :room_id }
  validates :role, presence: true

  before_create :set_joined_at

  scope :admins, -> { where(role: :admin) }
  scope :members, -> { where(role: :member) }

  private

  def set_joined_at
    self.joined_at ||= Time.current
  end
end
