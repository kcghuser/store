class RenameAdminStocksToStocks < ActiveRecord::Migration[7.1]
  def change
    rename_table :admin_stocks, :stocks
  end
end
