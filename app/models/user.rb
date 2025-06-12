class User < ApplicationRecord
  validates :name, presence: true
  validates :balance_usd, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :balance_btc, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_many :transactions, dependent: :destroy
end
