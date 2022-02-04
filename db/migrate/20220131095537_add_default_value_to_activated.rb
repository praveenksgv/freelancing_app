class AddDefaultValueToActivated < ActiveRecord::Migration[6.1]
  def up
    change_column_default :users, :activated, true
  end

  def down
    change_column_default :users, :activated, nil
  end
end
