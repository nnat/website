class AddApplyInfoToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :first_name, :string
    add_column :leads, :last_name,  :string
    add_column :leads, :post_code,  :string
    add_column :leads, :applied_at, :datetime
  end
end
