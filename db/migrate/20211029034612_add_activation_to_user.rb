class AddActivationToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :activated_at, :datetime, default: nil
  end
end
