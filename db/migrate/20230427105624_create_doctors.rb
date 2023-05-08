class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :name, unique: true
      t.string :image
      t.string :address
      t.time :start_time
      t.time :end_time
      t.time :lunch_time

      t.timestamps
    end
  end
end
