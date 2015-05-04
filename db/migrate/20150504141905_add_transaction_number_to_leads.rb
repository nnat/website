class AddTransactionNumberToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :transaction_number, :string
  end
end
