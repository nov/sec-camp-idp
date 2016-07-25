class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :identifier, null: false
      t.string :email, :name, :password_digest, null: false
      t.string :phone, :address
      t.datetime :last_logged_in_at
      t.timestamps
    end
    add_index :accounts, :identifier, unique: true
    add_index :accounts, :email, unique: true
  end
end
