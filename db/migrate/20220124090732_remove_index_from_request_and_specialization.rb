class RemoveIndexFromRequestAndSpecialization < ActiveRecord::Migration[6.1]
  def change
    remove_index :requests, name: "index_requests_on_user_id_and_job_id_and_method", unique: true
    remove_index :specializations, name: "index_specializations_on_user_id_and_name", unique: true
  end
end
