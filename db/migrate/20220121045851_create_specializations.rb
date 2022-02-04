class CreateSpecializations < ActiveRecord::Migration[6.1]
  def change
    create_table :specializations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
