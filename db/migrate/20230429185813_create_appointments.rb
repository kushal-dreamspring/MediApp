class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :doctor, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :date_time
      t.decimal :amount, precision: 10, scale: 2
      t.integer :currency, default: 0

      t.timestamps
    end
  end
end
