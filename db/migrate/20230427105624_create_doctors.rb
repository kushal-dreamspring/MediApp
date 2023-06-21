class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :name, null: false, unique: true
      t.string :image, null: false
      t.string :address, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.time :lunch_time, null: false

      t.timestamps
    end
  end
end
