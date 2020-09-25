class CreateContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.date :start_day , null: false
      t.date :finish_day , null: false
      t.integer :price , null: false
      t.references :company , null: false , foreign_key: true
      t.references :temporary , null: false , foreign_key: true
      t.references :user , null: false , foreign_key: true

      t.timestamps
    end
  end
end
