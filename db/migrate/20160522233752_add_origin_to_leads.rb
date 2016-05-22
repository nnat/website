class AddOriginToLeads < ActiveRecord::Migration
  def change
  	add_column :leads, :origin, :string
  end
end
