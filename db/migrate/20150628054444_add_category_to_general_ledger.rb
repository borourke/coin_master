class AddCategoryToGeneralLedger < ActiveRecord::Migration
  def change
    add_column :general_ledgers, :category, :string
  end
end
