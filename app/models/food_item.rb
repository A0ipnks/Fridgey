class FoodItem < ApplicationRecord
  belongs_to :room
  belongs_to :registered_by, class_name: 'User'
  belongs_to :used_by, class_name: 'User', optional: true

  validates :name, presence: true, length: { maximum: 100 }
  validates :category, presence: true
  validates :expiration_date, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 999 }
  validates :memo, length: { maximum: 500 }
  validates :restriction_tags, length: { maximum: 200 }

  enum :category, {
    vegetables: 0,     # 野菜
    fruits: 1,         # 果物
    meat: 2,           # 肉類
    fish: 3,           # 魚類
    dairy: 4,          # 乳製品
    grains: 5,         # 穀物・パン
    seasonings: 6,     # 調味料
    beverages: 7,      # 飲み物
    snacks: 8,         # スナック・お菓子
    frozen_food: 9,    # 冷凍食品
    others: 10         # その他
  }

  scope :expired, -> { where(expiration_date: ...Date.current) }
  scope :expiring_soon, -> { where(expiration_date: Date.current...3.days.from_now) }
  scope :fresh, -> { where(expiration_date: 3.days.from_now..) }
  scope :by_category, ->(cat) { where(category: cat) if cat.present? }
  scope :recent, -> { order(created_at: :desc) }

  def expired?
    expiration_date < Date.current
  end

  def expiring_soon?
    expiration_date <= 3.days.from_now && !expired?
  end

  def fresh?
    expiration_date > 3.days.from_now
  end

  def days_until_expiration
    (expiration_date - Date.current).to_i
  end

  def status_color
    if expired?
      'red'
    elsif expiring_soon?
      'yellow'
    else
      'green'
    end
  end

  def category_icon
    case category.to_sym
    when :vegetables then '🥬'
    when :fruits then '🍎'
    when :meat then '🥩'
    when :fish then '🐟'
    when :dairy then '🥛'
    when :grains then '🍞'
    when :seasonings then '🧂'
    when :beverages then '🥤'
    when :snacks then '🍪'
    when :frozen_food then '🧊'
    else '🍽️'
    end
  end
end
