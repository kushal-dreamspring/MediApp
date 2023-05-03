class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    User.create id: 0, name: 'John Doe', email: 'johndoe@test.com'
  end
end
