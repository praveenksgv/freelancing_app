class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :state
      t.decimal :budget, precision: 6, scale: 2

      t.timestamps
    end
  end
end
