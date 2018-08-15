class AddSenderIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sender_id, :string
  end
end
