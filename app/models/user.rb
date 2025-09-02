class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_rooms, class_name: 'Room', foreign_key: 'created_by_id', dependent: :destroy
  has_many :room_members, dependent: :destroy
  has_many :rooms, through: :room_members
  has_many :registered_food_items, class_name: 'FoodItem', foreign_key: 'registered_by_id', dependent: :destroy
  has_many :used_food_items, class_name: 'FoodItem', foreign_key: 'used_by_id', dependent: :nullify

  validates :display_name, length: { maximum: 30 }

  def admin_of?(room)
    room_members.find_by(room: room)&.admin?
  end

  def member_of?(room)
    room_members.exists?(room: room)
  end
end
