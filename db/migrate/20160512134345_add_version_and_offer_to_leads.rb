class AddVersionAndOfferToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :version, :string
    add_column :leads, :offer, :string
  end
end
