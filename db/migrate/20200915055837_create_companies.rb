class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name , null: false
      t.integer :annual_sales , null: false
      t.integer :capiral
      t.string :hp

      t.timestamps
    end
  end
end
