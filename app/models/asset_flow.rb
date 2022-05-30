class AssetFlow < ApplicationRecord
  enum flow_type: [:daily_benefit]

  belongs_to :user

  def flow_type_name
    if daily_benefit?
      'Daily benefit'
    else
      '--'
    end
  end

  def collect
    with_lock do
      User.where(id: id).update_all(['token_balance = token_balance + ?', amount])
      update(collected: true)
    end
  end
end
