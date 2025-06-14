class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :from_currency, :to_currency, :amount_from, :amount_to, :price_reference, :status, :created_at, :updated_at

  def amount_from
    format_amount(object.from_currency, object.amount_from)
  end

  def amount_to
    format_amount(object.to_currency, object.amount_to)
  end

  def price_reference
    object.price_reference.to_f.round(2)
  end

  private

  def format_amount(currency, amount)
    if currency == 'usd'
      amount.to_f.round(2)
    elsif currency == 'bitcoin'
      amount.to_f.round(8)
    else
      amount.to_f
    end
  end
end 