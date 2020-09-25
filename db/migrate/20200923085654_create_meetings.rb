class CreateMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :meetings do |t|
      t.string :company_name ,nul:false
      t.date :day ,nul:false
      t.datetime :time ,nul:false
      t.references :user ,nul:false ,foreign_key: true
      t.references :temporary ,nul:false ,foreign_key: true
      t.timestamps
    end
  end
end
