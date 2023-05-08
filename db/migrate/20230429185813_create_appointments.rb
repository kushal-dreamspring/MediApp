class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :doctor, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :date_time
      t.float :amount, default: 500.0
      t.integer :currency, default: 0

      t.timestamps
    end
  end
end
