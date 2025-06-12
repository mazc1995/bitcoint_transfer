class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :from_currency
      t.string :to_currency
      t.decimal :amount_from
      t.decimal :amount_to
      t.decimal :price_reference
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
