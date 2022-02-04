class AddUniqueConstraints < ActiveRecord::Migration[6.1]
  def change
    add_index :requests, [:user_id, :job_id, :method], unique: true
    add_index :specializations, [:user_id, :name], unique: true

  end
end
