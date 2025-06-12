class Transaction < ApplicationRecord
  belongs_to :user

  validates :from_currency, presence: true
  validates :to_currency, presence: true
  validates :amount_from, presence: true, numericality: { greater_than: 0 }
  validates :amount_to, presence: true, numericality: { greater_than: 0 }
  validates :price_reference, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending completed failed] }

  enum :status, { pending: 0, completed: 1, failed: 2 }
end
