class AddParentIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :parent_id, :bigint, comment: '邀请人ID'
    add_index :users, :parent_id
  end
end
