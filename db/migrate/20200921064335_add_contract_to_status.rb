class AddContractToStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :status_id , :integer
    add_column :contracts, :task_name , :string
  end
end
