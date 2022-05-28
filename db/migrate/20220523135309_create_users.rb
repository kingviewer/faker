class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, comment: '用户' do |t|
      t.string :address, null: false, limit: 50, index: { unique: true }, comment: '地址'
      t.decimal :usdt_balance, null: false, default: 0, precision: 20, scale: 8, index: true, comment: 'USDT余额'
      t.integer :nft_amount, null: false, default: 0, comment: 'NFT数量'
      t.integer :children_amount, null: false, default: 0, comment: '邀请的用户数'
      t.decimal :token_balance, null: false, default: 0, precision: 20, scale: 8, comment: 'Token余额'

      t.timestamps
    end
  end
end
