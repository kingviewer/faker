class User < ApplicationRecord

  belongs_to :parent, class_name: 'User', required: false
  has_many :children, class_name: 'User', foreign_key: :parent_id
  has_many :asset_flows
  has_many :withdraws
  has_many :nfts

  after_create :sync_parent

  def self.sync_parents
    User.where(parent_id: nil).each do |user|
      user.sync_parent
    end
  end

  def grandson_amount
    if children_amount > 0
      amount = 0
      children.each do |child|
        amount += child.children_amount
      end
      amount
    else
      0
    end
  end

  def sync_parent
    addr_parent = send_cmd(
      'get_parent',
      Utils::Constants::BSC_PRC,
      Utils::Constants::CONTRACT,
      address
    )
    if (user = User.find_by_address(addr_parent))
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
    # update(nft_amount: block_nft_list.size)
    nfts = []
    block_nft_list.each do |token_id|
      level = block_nft_level(token_id)
      nfts << {
        token_id: token_id,
        level: level
      }
    end
    Nft.where(user: self).delete_all
    nfts.each do |n|
      Nft.create(user: self, token_id: n[:token_id], level: n[:level])
    end
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

  def block_nft_level(token_id)
    send_cmd(
      'nft_level',
      Utils::Constants::BSC_PRC,
      Utils::Constants::CONTRACT,
      token_id
    )
  end

  def daily_benefit
    nfts.each do |nft|
      amount = nft.release_amount
      if amount > 0
        AssetFlow.create(user: self, amount: amount, flow_type: :daily_benefit)
      end
    end
    # base_amount = BigDecimal(100, 6)
    # nft_amount.times do
    #   AssetFlow.create(user: self, amount: base_amount, flow_type: :daily_benefit)
    # end
    # reward = BigDecimal(20, 6) * children_amount +
    #   BigDecimal(10, 6) * grandson_amount
    # AssetFlow.create(user: self, amount: reward, flow_type: :team_reward)
  end

  def total_investment
    total = 0
    nfts.each do |nft|
      total += nft.investment
    end
    total
  end

end
