class CreateAssetFlows < ActiveRecord::Migration[6.1]
  def change
    create_table :asset_flows do |t|
      t.references :user, null: false, index: true, comment: '用户ID'
      t.decimal :amount, null: false, precision: 20, scale: 8, comment: '数量'
      t.integer :flow_type, null: false, index: true, comment: '流水类型'
      t.boolean :collected, null: false, default: false, index: true, comment: '是否已到账'

      t.timestamps
    end
  end
end
