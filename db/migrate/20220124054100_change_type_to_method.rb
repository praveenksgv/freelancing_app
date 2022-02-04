class ChangeTypeToMethod < ActiveRecord::Migration[6.1]
  def change
    rename_column :requests, :type, :method
  end
end
