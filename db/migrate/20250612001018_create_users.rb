class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.decimal :balance_usd, precision: 16, scale: 2
      t.decimal :balance_btc, precision: 16, scale: 8

      t.timestamps
    end
  end
end
