class CreateGeneralLedger < ActiveRecord::Migration
  def change
    create_table :general_ledgers do |t|
      t.integer :user_id 
      t.string :kind
      t.string :name
      t.datetime :date
      t.decimal :amount
      t.boolean :recurring

      t.timestamps null: false
    end
  end
end
