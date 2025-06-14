class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :balance_usd, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :balance_btc, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :email, presence: true, uniqueness: true

  has_many :transactions, dependent: :destroy
end
