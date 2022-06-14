class CreateWithdraws < ActiveRecord::Migration[6.1]
  def change
    create_table :withdraws do |t|
      t.references :user, null: false, index: true, comment: '用户ID'
      t.decimal :amount, null: false, precision: 18, scale: 6, comment: '数量'
      t.string :address, null: false, limit: 50, index: true, comment: '收币地址'
      t.integer :state, null: false, default: 0, index: true, comment: '状态'

      t.timestamps
    end
  end
end
