class User < ApplicationRecord

  belongs_to :parent, class_name: 'User', required: false
  has_many :children, class_name: 'User', foreign_key: :parent_id
  has_many :asset_flows

  after_create :sync_parent

  def self.sync_parents
    User.where(parent_id: nil) do |user|
      user.sync_parent
    end
  end

  def grandson_amount
    if children_amount > 0
      amount = children_amount
      children.each do |child|
        amount += child.children_amount
      end
      amount
    else
      0
    end
  end

  def sync_parent
    p = send_cmd(
      'get_parent',
      Utils::Constants::BSC_PRC,
      Utils::Constants::CONTRACT_USDT,
      address
    )
    if (user = User.find_by_address(p))
      update(parent_id: user.id)
    end
  end

  def sync_usdt
    update(usdt_balance: block_usdt_balance)
  end

  def sync_children_amount
    update(children_amount: block_children_amount)
  end

  def sync_nft_amount
    update(nft_amount: block_nft_list.size)
  end

  def block_usdt_balance
    BigDecimal(
      send_cmd(
        'erc20_balance',
        Utils::Constants::BSC_PRC,
        Utils::Constants::CONTRACT_USDT,
        address
      )
    ) * 10 ** -18
  end

  def block_children_amount
    send_cmd(
      'children_amount',
      Utils::Constants::BSC_PRC,
      Utils::Constants::CONTRACT,
      address
    ).to_i
  end

  def block_nft_list
    eval(
      send_cmd(
        'nft_of_owner',
        Utils::Constants::BSC_PRC,
        Utils::Constants::CONTRACT,
        address
      )
    )
  end

  def daily_benefit
    return unless nft_amount > 0
    base_amount = BigDecimal(100, 6)
    nft_amount.times do
      AssetFlow.create(user: self, amount: base_amount, flow_type: :daily_benefit)
    end
    reward = BigDecimal(20, 6) * children_amount +
      BigDecimal(10, 6) * grandson_amount
    AssetFlow.create(user: self, amount: reward, flow_type: :team_reward)
  end

end
