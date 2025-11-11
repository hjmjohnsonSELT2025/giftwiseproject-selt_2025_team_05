class AddEmailNamesDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :email, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :string
    add_column :users, :birthdate, :string
  end
end
