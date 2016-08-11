class CreateSigningKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :signing_keys do |t|
      t.text :pem, null: false
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
