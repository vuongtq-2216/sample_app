class ChangeAdminColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :admin, :is_admin
  end
end
