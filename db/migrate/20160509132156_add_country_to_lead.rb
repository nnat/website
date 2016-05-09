class AddCountryToLead < ActiveRecord::Migration
  def change
    add_column :leads, :country, :string
  end
end
