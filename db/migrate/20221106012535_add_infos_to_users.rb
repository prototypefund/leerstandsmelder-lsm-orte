class AddInfosToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nickname, :string
    add_column :users, :confirmed, :boolean, default: false
    add_column :users, :blocked, :boolean, default: false
    add_column :users, :message_me, :boolean, default: false
    add_column :users, :notify, :boolean, default: false
    add_column :users, :share_email, :boolean, default: false
    add_column :users, :accept_terms, :boolean, default: false
    add_column :users, :legacy_id, :string
  end
end
