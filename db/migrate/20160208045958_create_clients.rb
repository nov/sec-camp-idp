class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :identifier, :secret, :name, null: false
      t.text :redirect_uris, null: false
      t.timestamps
    end
    add_index :clients, :identifier, unique: true
  end
end
