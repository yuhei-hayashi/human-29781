class CreateTemporaries < ActiveRecord::Migration[6.0]
  def change
    create_table :temporaries do |t|
      t.string :full_name , null: false
      t.string :full_name_reading , null: false
      t.integer :temporary_number 
      t.date :birthday , null: false
      t.date :hire_date , null: false
      t.integer :genre_id , null: false
      t.integer :contract_status_id , null: false
      t.string :telephone
      t.string :mail

      t.timestamps
    end
  end
end
