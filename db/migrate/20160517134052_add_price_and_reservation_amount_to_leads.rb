class AddPriceAndReservationAmountToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :price, :integer
    add_column :leads, :reservation_amount, :integer
  end
end
