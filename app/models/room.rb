class Room < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  has_many :room_members, dependent: :destroy
  has_many :users, through: :room_members
  has_many :food_items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :invitation_code, presence: true, uniqueness: true
  validates :description, length: { maximum: 500 }

  before_validation :generate_invitation_code, on: :create

  private

  def generate_invitation_code
    return if invitation_code.present?
    self.invitation_code = SecureRandom.alphanumeric(8).upcase
  end
end
