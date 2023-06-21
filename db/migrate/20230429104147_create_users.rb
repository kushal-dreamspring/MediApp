class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        User.create id: 0, name: 'John Doe', email: 'johndoe@test.com'
      end
      dir.down do
        User.delete id: 0
      end
    end
  end
end
