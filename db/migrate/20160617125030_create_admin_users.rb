# frozen_string_literal: true
class CreateAdminUsers < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string     :encrypted_email, null: false
      t.string     :password_hash, null: false
      t.string     :role, null: false
      t.boolean    :active, null: false, default: false
      t.jsonb      :setting, null: false, default: "{}"

      t.timestamps null: false
    end
    add_index :admin_users, :encrypted_email, unique: true
  end
end
