class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string     :encrypted_email,  null: false
      t.string     :password_hash,    null: false
      t.boolean    :active,           null: false, default: true
      t.boolean    :email_verified,   null: false, default: true
      t.string     :encrypted_first_name
      t.string     :encrypted_last_name
    end

    execute <<-SQL
      CREATE UNIQUE INDEX index_users_on_encrypted_email
        ON users
        USING btree
        (encrypted_email COLLATE pg_catalog."default");
    SQL
  end

  def down
    drop_table :users
  end
end
