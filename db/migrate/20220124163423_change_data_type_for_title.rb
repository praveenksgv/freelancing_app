class ChangeDataTypeForTitle < ActiveRecord::Migration[6.1]
  def change
    change_column :jobs, :title, :text
  end
end
