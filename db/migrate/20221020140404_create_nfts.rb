class CreateNfts < ActiveRecord::Migration[6.1]
  def change
    create_table :nfts, comment: 'NFT' do |t|
      t.references :user, null: false, index: true, comment: '用户ID'
      t.bigint :token_id, null: false, index: true, comment: 'TOKEN ID'
      t.integer :level, null: false, index: true, comment: 'Level'

      t.timestamps
    end
  end
end
