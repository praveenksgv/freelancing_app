class AddSkillsToJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :skills, :string
  end
end
